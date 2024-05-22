extends Control

onready var panelBG = $VictoryBG

func _ready():
	EventBusSingleton.connect_event("enemy_base_destroyed", self, "_on_enemy_base_destroyed")
	panelBG.visible = false
	set_process_input(false) # Disable player interaction initially

func _on_enemy_base_destroyed():
	panelBG.visible = true
	set_process_input(true) # Enable player interaction when panelBG is visible
