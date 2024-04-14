extends Node2D

var positions: Array
export var mana_rate = 1.0

onready var ysort = $YSort
onready var mana_points:RichTextLabel = $Panel/ManaPoints

var mana_count = 0
var timer = 0


func _ready():
	searchRootPositionNodes()
	connectToSummonEvents()
	setManaPoints(mana_count)

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
		
	var randomNumber = randi() % positions.size()
	var spawnPosition = positions[randomNumber]
	instance.position = spawnPosition.global_position
	ysort.add_child(instance)

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
	mana_points.bbcode_text = "[center][right]" + str(value)
