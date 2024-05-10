extends Node2D

class_name SpawnEnemyController

export var health = 100
export var spawn_rate = 1.5

export(NodePath) var pos1_path:NodePath
export(NodePath) var pos2_path:NodePath
export(NodePath) var pos3_path:NodePath

onready var pos1:Position2D = null
onready var pos2:Position2D = null
onready var pos3:Position2D = null

export(PackedScene) var unit
export(NodePath) var ysort_path

onready var ysort = null


var timer = 0

# Hp Bar Texture Progress Bar
var hpBar: TextureProgress

func _ready():
	ysort = get_node(ysort_path)
	hpBar = $CrystalHpBar
	hpBar.max_value = health
	hpBar.value = health

	timer = 0

	set_paths()

	add_to_group("EnemySpawner")

func _process(delta):
	timer += delta
	if timer >= spawn_rate:
		timer = 0
		spawnUnit()

func receive_damage(damage):
	health -= damage
	hpBar.value -= damage

	if health <= 0:
		destroy()

func spawnUnit():
	var instance = unit.instance()
	var randomNumber = randi() % 3 + 1

	ysort.add_child(instance)

	match randomNumber:
		1:
			instance.global_position = pos1.global_position
		2:
			instance.global_position = pos2.global_position
		3:
			instance.global_position = pos3.global_position

	instance.set_velocity(Vector2.LEFT)
	instance.set_state(1)

func set_paths():
	if pos1_path:
		pos1 = get_node(pos1_path)

	if pos2_path:
		pos2 = get_node(pos2_path)

	if pos3_path:
		pos3 = get_node(pos3_path)

func destroy():
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
