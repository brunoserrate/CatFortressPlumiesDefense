extends Node2D

class_name SpawnEnemyController

export var health = 100

# Hp Bar Texture Progress Bar
var hpBar: TextureProgress

# TODO: Add a way to set the enemy type

func _ready():
	hpBar = $CrystalHpBar
	hpBar.max_value = health
	hpBar.value = health

func receive_damage(damage):
	health -= damage
	hpBar.value -= damage

	if health <= 0:
		queue_free()
