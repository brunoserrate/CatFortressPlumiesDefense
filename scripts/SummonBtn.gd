extends Button

signal summon_unit(unit)

export(PackedScene) var unit_type
var unit_node
var spawn_allied_controller: SpawnAlliedController

func _ready():
	connect("pressed", self, "_on_Button_pressed")
	unit_node = unit_type.instance()

	# get the spawn_allied_controller from root scene children
	var root = get_tree().get_root()

	for child in root.get_children():
		if child.has_node("SpawnAlliedController"):
			spawn_allied_controller = child.get_node("SpawnAlliedController")
			break

func _process(delta):
	if(spawn_allied_controller.get_mana_points() <= unit_node.cost):
		self.disabled = true
	else:
		self.disabled = false

func _on_Button_pressed():
	emit_signal("summon_unit", unit_type)
