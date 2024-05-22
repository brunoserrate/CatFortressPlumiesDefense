extends Control

onready var panelBG = $DefeatedBG

func _ready():
	if PauseManager.isGamePaused():
		PauseManager.unpause()

	EventBusSingleton.connect_event("allied_base_destroyed", self, "_on_allied_base_destroyed")
	panelBG.visible = false
	set_process_input(false) # Disable player interaction initially

func _on_allied_base_destroyed():
	panelBG.visible = true
	set_process_input(true) # Disable player interaction initially

func _on_TryAgainBtn_pressed():
	get_tree().reload_current_scene()
