extends KinematicBody2D

export(float) var speed = 100
export(String) var group_name

export var can_rotate:bool = false

var velocity = Vector2.ZERO
var target = null
var damage = 0

var group_list = []

func _ready():
	add_to_group(group_name)

func _physics_process(delta):
	if (velocity == Vector2.ZERO):
		return

	var collisions = move_and_collide(velocity * delta)

	if !collisions:
		return

	for group in group_list:
		if collisions.collider.is_in_group(group):
			collisions.collider.receive_damage(damage)
			queue_free()

func set_target(_target):
	target = _target

func set_damage(_damage):
	damage = _damage

func set_group_list(_group_list):
	group_list = _group_list

func set_velocity():
	if is_instance_valid(target) and velocity == Vector2.ZERO:  # Só define se a velocidade ainda não foi definida
		velocity = (target.global_position - global_position).normalized() * speed

		if can_rotate:
			rotation = velocity.angle()
