class_name SpawnEnemyController

extends Node2D

export var health = 100
var spawn_rate = 1.5

export(Resource) var enemy_spawn_set:Resource

export(NodePath) var pos1_path:NodePath
export(NodePath) var pos2_path:NodePath
export(NodePath) var pos3_path:NodePath

onready var pos1:Position2D = null
onready var pos2:Position2D = null
onready var pos3:Position2D = null

# export(PackedScene) var unit
export(NodePath) var ysort_path

onready var ysort = null

onready var animation_player = $AnimationPlayer
onready var animated_sprite = $AnimatedSprite
var died = false

var hpBar: TextureProgress

var spawn_timer = 0
var spawn_set_timer = 0
var spawn_set_index = 0
var level_spawn_set = null
var current_spawn_set = null

func _ready():
	EventBusSingleton.register_event("enemy_base_destroyed")
	animation_player.play("idle")
	ysort = get_node(ysort_path)
	hpBar = $CrystalHpBar
	hpBar.max_value = health
	hpBar.value = health

	spawn_timer = 0

	set_paths()

	add_to_group("EnemySpawner")

	load_spawn_set_file()


func _process(delta):
	if(died):
		return

	check_spawn_set(delta)
	check_spawn(delta)

func receive_damage(damage):
	if(died):
		return

	health -= damage
	hpBar.value -= damage

	if health <= 0:
		destroy()

func check_spawn_set(delta):
	if spawn_set_index >= level_spawn_set.size():
		return

	spawn_set_timer += delta

	if spawn_set_timer >= current_spawn_set["time_to_begin"]:
		spawn_set_index += 1

		if spawn_set_index >= level_spawn_set.size():
			return

		current_spawn_set = level_spawn_set[spawn_set_index]

func check_spawn(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_rate:
		spawn_timer = 0
		spawnUnit()

func spawnUnit():
	randomize()
	var random_unit = floor(rand_range(0, current_spawn_set["enemies_to_spawn"].size()))
	var unit = current_spawn_set["enemies_to_spawn"][random_unit]

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
	died = true
	$AnimatedSprite.play("destroyed")
	yield($AnimatedSprite, "animation_finished")
	EventBusSingleton.emit_event("enemy_base_destroyed")
	PauseManager.pause()
	queue_free()

func load_spawn_set_file():
	if enemy_spawn_set:
		enemy_spawn_set.load_enemy_spawn_set()

		if(enemy_spawn_set.level_enemy_spawn_set == null || enemy_spawn_set.level_enemy_spawn_set.size() == 0):
			print("Erro ao carregar o template!")
			return

		level_spawn_set = enemy_spawn_set.level_enemy_spawn_set

		current_spawn_set = level_spawn_set[0]

		if(level_spawn_set[0]["change_spawn_time"]):
			spawn_rate = level_spawn_set[0]["changed_spawn_time"]

	else:
		print("Erro ao carregar o template!")
