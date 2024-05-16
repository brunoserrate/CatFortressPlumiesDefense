extends Control

onready var panelBG = $VictoryBG

func _ready():
	EventBusSingleton.connect_event("enemy_base_destroyed", self, "_on_enemy_base_destroyed")
	panelBG.visible = false

func _on_enemy_base_destroyed():
	panelBG.visible = true
