extends Control
onready var animation_player = $AnimationPlayer

export(PackedScene) var first_scene

func _on_PlayBtn_pressed():
	get_tree().change_scene_to(first_scene)

func _on_ExitBtn_pressed():
	get_tree().quit()
