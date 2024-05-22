extends TextureButton

signal summon_unit(unit)

export(PackedScene) var unit_type
var unit_node
var spawn_allied_controller: SpawnAlliedController

onready var text_cost = $RichTextLabel
onready var summon_outline = $SummonAvailableOutline

func _ready():
	connect("pressed", self, "_on_TextureButton_pressed")
	unit_node = unit_type.instance()

	text_cost.bbcode_text = "[color=black][right]" + str(unit_node.cost)

	var root = get_tree().get_root()

	for child in root.get_children():
		if child.has_node("SpawnAlliedController"):
			spawn_allied_controller = child.get_node("SpawnAlliedController")
			break

func _process(delta):
	if(spawn_allied_controller.get_mana_points() < unit_node.cost):
		summon_outline.visible = false
	else:
		summon_outline.visible = true

func _on_TextureButton_pressed():
	if(spawn_allied_controller.get_mana_points() < unit_node.cost):
		return
	
	emit_signal("summon_unit", unit_type)
