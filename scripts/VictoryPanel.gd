extends Control

onready var panelBG = $VictoryBG

export(String, FILE, "*.tscn") var next_level_scene
export(String, FILE, "*.tscn") var main_menu_scene


func _ready():
	EventBusSingleton.connect_event("enemy_base_destroyed", self, "_on_enemy_base_destroyed")
	panelBG.visible = false
	set_process_input(false)

func _on_enemy_base_destroyed():
	panelBG.visible = true
	set_process_input(true)

func _on_NextLevelBtn_pressed():
	if(next_level_scene):
		AudioManager.stop_all_sounds()
		get_tree().change_scene(next_level_scene)

func _on_BackToMenuBtn_pressed():
	if(main_menu_scene):
		AudioManager.stop_all_sounds()		
		get_tree().change_scene(main_menu_scene)
