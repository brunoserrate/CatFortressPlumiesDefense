extends Control

onready var panelBG = $DefeatedBG

func _ready():
	EventBusSingleton.connect_event("allied_base_destroyed", self, "_on_allied_base_destroyed")
	panelBG.visible = false

func _on_allied_base_destroyed():
	panelBG.visible = true

func _on_TryAgainBtn_pressed():
	print("Try Again")
	var result = get_tree().reload_current_scene()
	print(result)
