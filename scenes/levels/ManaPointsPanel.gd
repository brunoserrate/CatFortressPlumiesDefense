extends Panel

onready var mana_points = $ManaPoints

func _ready():
	EventBusSingleton.connect_event("mana_changed", self, "_on_mana_points_changed")
	
func _on_mana_points_changed(value):
	mana_points.bbcode_text = "[center][right]" + str(value)
