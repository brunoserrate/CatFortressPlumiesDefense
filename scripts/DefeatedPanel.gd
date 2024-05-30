extends Control

onready var panelBG = $DefeatedBG

export(String, FILE, "*.tscn") var main_menu_scene

func _ready():
	if PauseManager.isGamePaused():
		PauseManager.unpause()

	EventBusSingleton.connect_event("allied_base_destroyed", self, "_on_allied_base_destroyed")
	panelBG.visible = false
	set_process_input(false)

func _on_allied_base_destroyed():
	panelBG.visible = true
	set_process_input(true)

func _on_TryAgainBtn_pressed():
	AudioManager.stop_all_sounds()
	get_tree().reload_current_scene()

func _on_BackToMenuBtn_pressed():
	if(main_menu_scene):
		AudioManager.stop_all_sounds()
		get_tree().change_scene(main_menu_scene)
