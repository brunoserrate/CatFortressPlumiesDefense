extends KinematicBody2D

const GlobalEnums = preload("res://scripts/GlobalEnums.gd")

export var move_speed = 100
export var attack_power = 10
export var attack_rate = 1.5
"""
80 works better for melee
150 works better for ranged
"""
export var attack_range = 80
export var defense = 5
export var max_health = 100

var velocity = Vector2.ZERO
onready var health = max_health
var state = GlobalEnums.UnitState.IDLE

var current_target = null
var target_list = []
var attack_timer = 0

var hpBar: TextureProgress

func _ready():
	hpBar = $HpBar
	hpBar.max_value = health
	hpBar.value = health
	hpBar.visible = false
	add_to_group("EnemyUnit")
	$AnimatedSprite.play("run")

func _process(delta):
	clear_invalid_targets()
	if(target_list.size() > 0):
		set_nearest_target(target_list[0])

	match state:
		GlobalEnums.UnitState.IDLE:
			pass
		GlobalEnums.UnitState.MOVING:
			move_and_collide(velocity * delta)

			if is_instance_valid(current_target) and current_target != null and current_target.health > 0:
				if (current_target.global_position - global_position).length() <= attack_range:
					state = GlobalEnums.UnitState.ATTACKING
				else:
					set_target_position(current_target)
		GlobalEnums.UnitState.ATTACKING:
			if(current_target == null || !is_instance_valid(current_target) || current_target.health <= 0):
				set_velocity(Vector2.LEFT)
				state = GlobalEnums.UnitState.MOVING
				return

			velocity = Vector2.ZERO
			attack(delta)

func set_target_position(target):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	current_target = target
	state = GlobalEnums.UnitState.MOVING

func set_velocity(vel):
	velocity = vel * move_speed

func set_state(new_state):
	state = new_state

func receive_damage(damage):
	var calc_damage = damage - defense
	health -= calc_damage if calc_damage > 0 else 1

	if(!hpBar.visible):
		hpBar.visible = true

	hpBar.value = health
	if health <= 0:
		die()

func die():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()

func _on_AttackArea_area_entered(area):
	var parent = area.get_parent()
	if parent and parent.is_in_group("AlliedUnit"):
		if(current_target == null || !is_instance_valid(current_target) || current_target.health <= 0):
			target_list.append(parent)
			set_nearest_target(parent)

func attack(delta):
	attack_timer += delta

	if attack_timer < attack_rate:
		return

	if is_instance_valid(current_target):
		current_target.receive_damage(attack_power)
		attack_timer = 0

		if(current_target.health <= 0):
			for i in range(target_list.size()):
				if target_list[i] == current_target:
					target_list.remove(i)
					break

		if !is_instance_valid(current_target) || current_target != null:
			current_target = null
			if(target_list.size() > 0):
				set_nearest_target(target_list[0])
			else:
				set_velocity(Vector2.LEFT)
				state = GlobalEnums.UnitState.MOVING
	else:
		set_velocity(Vector2.LEFT)
		state = GlobalEnums.UnitState.MOVING

func set_nearest_target(target):
	if target == null || !is_instance_valid(target):
		return

	if current_target == null || !is_instance_valid(current_target):
		current_target = target
		return

	if (target.global_position - global_position).length() < (current_target.global_position - global_position).length():
		current_target = target
		return

func clear_invalid_targets():
	if(target_list.size() <= 0):
		return

	for i in range(target_list.size()):
		if target_list[i] == null or !is_instance_valid(target_list[i]):
			target_list.remove(i)
			break
