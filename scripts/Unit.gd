class_name Unit extends KinematicBody2D

const GlobalEnums = preload ("res://scripts/GlobalEnums.gd")

export var attack_power = 10
export var attack_rate = 1.5
export(GlobalEnums.UnitAttackType) var attack_type

export var max_health = 100
export var defense = 5

export var move_speed = 100

export var cost = 10

export var delay_to_die = 0.2
export(Vector2) var default_direction = Vector2.RIGHT

# group list to check
export var group_list = ["EnemyUnit", "EnemySpawner", "AlliedUnit", "AlliedSpawner"]

export(PackedScene) var projectile
export(Vector2) var projectile_offset = Vector2(40, 20)

onready var health = max_health
onready var state = GlobalEnums.UnitState.IDLE
onready var health_bar = $HealthBar
onready var attack_area = $AttackArea
onready var attack_timer = attack_rate
onready var animated_sprite = $AnimatedSprite

var velocity = Vector2.ZERO
var target = null
var target_list = []

func _ready():
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.visible = false

	animated_sprite.play("run")

func _process(delta):
	if(attack_animation_is_playing()):
		return

	match state:
		GlobalEnums.UnitState.IDLE:
			pass
		GlobalEnums.UnitState.MOVING:
			move_unit(delta)
		GlobalEnums.UnitState.ATTACKING:
			attack(delta)

func _on_AttackArea_area_entered(area):
	var parent = area.get_parent()

	if state == GlobalEnums.UnitState.IDLE or state == GlobalEnums.UnitState.MOVING:
		if attack_type == GlobalEnums.UnitAttackType.RANGED:
			for group in group_list:
				if parent.is_in_group(group):
					target = parent
					target_list.append(parent)
					clear_invalid_targets()
					set_nearest_target()
					state = GlobalEnums.UnitState.ATTACKING
					set_velocity(Vector2.ZERO)
					return
		elif attack_type == GlobalEnums.UnitAttackType.MELEE:
			for group in group_list:
				if parent.is_in_group(group):
					if target_list.size() > 0:
						target_list.append(parent)
						clear_invalid_targets()
					set_target_position(parent)
					return

# Internal functions
func move_unit(delta):
	if(animated_sprite.animation != "run"):
		animated_sprite.play("run")

	if(velocity == Vector2.ZERO):
		set_velocity(default_direction)

	var collisions = move_and_collide(velocity * delta)

	if(collisions):
		for group in group_list:
			if(collisions.collider.is_in_group(group)):
				target = collisions.collider
				state = GlobalEnums.UnitState.ATTACKING
				velocity = Vector2.ZERO
				return

func receive_damage(damage):
	if(health <= 0):
		return

	var calc_damage = max(1, damage - defense)

	health -= calc_damage

	if(!health_bar.visible):
		health_bar.visible = true

	health_bar.value = health

	if(health <= 0):
		health = 0;
		die()

func die():
	yield(get_tree().create_timer(delay_to_die), "timeout")
	queue_free()

func attack(delta):
	if(!is_instance_valid(self)):
		return

	if(!is_instance_valid(target) || target == null):
		state = GlobalEnums.UnitState.MOVING
		return

	if(attack_animation_is_playing()):
		return

	attack_timer += delta

	if(attack_timer < attack_rate):
		return

	attack_timer = 0

	state = GlobalEnums.UnitState.ATTACKING

	if(animated_sprite.frames.has_animation("attack")):
		animated_sprite.play("attack")

	yield(get_tree().create_timer(0.1), "timeout")
	yield(animated_sprite, "animation_finished")

	if(!is_instance_valid(self)):
		return

	if(!is_instance_valid(target) || target == null):
		state = GlobalEnums.UnitState.MOVING
		return

	if(attack_type == GlobalEnums.UnitAttackType.RANGED):
		if(projectile == null):
			return

		var projectile_instance = projectile.instance()
		projectile_instance.global_position = global_position + projectile_offset

		projectile_instance.set_target(target)
		projectile_instance.set_damage(attack_power)
		projectile_instance.set_group_list(group_list)

		get_parent().add_child(projectile_instance)  # Adicione à cena primeiro
		projectile_instance.set_velocity()  # Então configure a velocidade
	elif(attack_type == GlobalEnums.UnitAttackType.MELEE):
		target.receive_damage(attack_power)


	if(target.health <= 0):
		target = null
		state = GlobalEnums.UnitState.MOVING

	animated_sprite.play("run")


# Axuiliary functions
func attack_animation_is_playing():
	if(animated_sprite.animation == "attack"):
		if(animated_sprite.frame < animated_sprite.frames.get_frame_count("attack") - 1):
			return true

	return false

func set_state(new_state):
	state = new_state

func set_velocity(new_velocity):
	velocity = new_velocity * move_speed

func set_target_position(new_target):
	var direction = (new_target.global_position - global_position).normalized()
	velocity = direction * move_speed

func set_nearest_target():
	if(target_list.size() == 0):
		return

	# first target from the list
	var nearest_target = target_list[0]

	# new list of targets
	var new_target_list = []

	# distance to the first target
	var nearest_distance = global_position.distance_to(nearest_target.global_position)

	# find the nearest target
	for target_unit in target_list:
		var distance = global_position.distance_to(target.global_position)

		if(distance < nearest_distance):
			nearest_target = target_unit
			nearest_distance = distance
		else:
			new_target_list.append(target_unit)

	target_list = new_target_list
	target_list.insert(0, nearest_target)
	target = nearest_target

func clear_invalid_targets():
	var new_target_list = []

	for target_unit in target_list:
		if(is_instance_valid(target_unit)):
			new_target_list.append(target_unit)

	target_list = new_target_list

