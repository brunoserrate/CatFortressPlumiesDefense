extends KinematicBody2D

enum State { IDLE, MOVING, ATTACKING }

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
export var cost = 10

var velocity = Vector2.ZERO
var health = max_health
var state = State.IDLE

var current_target = null
var attack_timer = 0


func _ready():
	$AnimatedSprite.play("run")

func _process(delta):
	match state:
		State.IDLE:
			pass
		State.MOVING:
			move_and_collide(velocity * delta)

			if is_instance_valid(current_target) and current_target != null and current_target.health > 0:
				if (current_target.position - position).length() <= attack_range:
					# print_debug("Range: " + str((current_target.position - position).length()) + " Attack Range: " + str(attack_range))
					state = State.ATTACKING
		State.ATTACKING:
			attack(delta)

func set_target_position(target):
	var direction = (target.position - position).normalized()
	velocity = direction * move_speed
	current_target = target
	state = State.MOVING

func set_velocity(vel):
	velocity = vel * move_speed

func set_state(new_state):
	state = new_state

func receive_damage(damage):
	health -= damage - defense
	if health <= 0:
		die()

func die():
	queue_free()

func _on_AttackArea_area_entered(area):
	# From area, try to get the parent of the area
	# If the parent is an instance of the class SpawnEnemyController
	# Then call the receive_damage method of the area
	# Pass the attack_power as an argument
	var parent = area.get_parent()
	if parent and parent is SpawnEnemyController:
		current_target = parent


func attack(delta):
	attack_timer += delta

	if attack_timer < attack_rate:
		return

	if current_target:
		current_target.receive_damage(attack_power)
		attack_timer = 0

		if !is_instance_valid(current_target) || (current_target != null && current_target.health <= 0):
			current_target = null
			state = State.MOVING
