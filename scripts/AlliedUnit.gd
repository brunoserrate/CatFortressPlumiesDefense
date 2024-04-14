extends KinematicBody2D

export var move_speed = 100
export var attack_power = 10
export var defense = 5
export var max_health = 100
export var cost = 10

var velocity = Vector2.ZERO
var health = max_health

func _ready():
	velocity = Vector2.RIGHT * move_speed

func _process(delta):
	move_and_collide(velocity * delta)


func set_target_position(target_position):
	var direction = (target_position - position).normalized()
	velocity = direction * move_speed

func receive_damage(damage):
	health -= damage - defense
	if health <= 0:
		die()

func die():
	queue_free()
