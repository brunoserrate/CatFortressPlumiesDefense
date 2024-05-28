class_name SpawnEnemyController

extends Node2D

export var health = 100
export var spawn_rate = 1.5

export(Resource) var enemy_spawn_set:Resource

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
onready var animation_player = $AnimationPlayer
onready var animated_sprite = $AnimatedSprite
var died = false

# Hp Bar Texture Progress Bar
var hpBar: TextureProgress

func _ready():
	EventBusSingleton.register_event("enemy_base_destroyed")
	animation_player.play("idle")
	ysort = get_node(ysort_path)
	hpBar = $CrystalHpBar
	hpBar.max_value = health
	hpBar.value = health

	timer = 0

	set_paths()

	add_to_group("EnemySpawner")

	load_spawn_set_file()


func _process(delta):
	if(died):
		return

	timer += delta
	if timer >= spawn_rate:
		timer = 0
		spawnUnit()

func receive_damage(damage):
	if(died):
		return

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
	died = true
	$AnimatedSprite.play("destroyed")
	yield($AnimatedSprite, "animation_finished")
	EventBusSingleton.emit_event("enemy_base_destroyed")
	PauseManager.pause()
	queue_free()

func load_spawn_set_file():
	# Verificar se o recurso está configurado
	if enemy_spawn_set:
		enemy_spawn_set.load_enemy_spawn_set()
		print("Template carregado com sucesso!")
		for spawn_set in enemy_spawn_set.enemy_spawn_set:
			print(spawn_set["enemies_to_spawn"][0])
	else:
		print("Erro ao carregar o template!")
