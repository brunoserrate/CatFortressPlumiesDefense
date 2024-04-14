extends Button

signal summon_unit(unit)

export(PackedScene) var unit_type

func _ready():
	connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	emit_signal("summon_unit", unit_type)
