class_name SpawnAlliedController

extends Node2D

var positions: Array
export var mana_rate: float = 1.0

export(NodePath) var enemy_spawner

export(NodePath) var ysort_path

onready var ysort = null

var mana_count = 0
var timer = 0

onready var animation_player = $AnimationPlayer
onready var animated_sprite = $AnimatedSprite

func _ready():
	EventBusSingleton.register_event("mana_changed")
	EventBusSingleton.connect_event("enemy_base_destroyed", self, "_on_enemy_base_destroyed")
	animation_player.play("crystalIdleAnimation")
	ysort = get_node(ysort_path)
	searchRootPositionNodes()
	connectToSummonEvents()
	setManaPoints(mana_count)

	add_to_group("AlliedSpawner")

func _process(delta):
	timer += delta
	if timer >= mana_rate:
		timer = 0
		mana_count += 1
		setManaPoints(mana_count);

func spawn(unit):
	var instance = unit.instance()
	if mana_count < instance.cost:
		return

	ysort.add_child(instance)

	var randomNumber = randi() % positions.size()
	var spawnPosition = positions[randomNumber]
	instance.position = spawnPosition.global_position

	instance.set_velocity(Vector2.RIGHT)
	instance.set_state(1)


	mana_count -= instance.cost
	setManaPoints(mana_count)


func connectToSummonEvents():
	var btns = []
	var scene = get_tree().get_current_scene()
	var summonBtns = scene.get_node("SummonBtns")

	if !summonBtns:
		return

	btns = summonBtns.get_children()

	for btn in btns:
		btn.connect("summon_unit", self, "spawn")

func searchRootPositionNodes():
	var root = get_tree().get_current_scene()
	var rootChildren = root.get_children()

	for child in rootChildren:
		if child.name == "PositionNodes":
			positions = child.get_children()
			break

func setManaPoints(value):
	EventBusSingleton.emit_event("mana_changed", value)

func get_mana_points():
	return mana_count

func _on_enemy_base_destroyed():
	animated_sprite.z_index -= 1
