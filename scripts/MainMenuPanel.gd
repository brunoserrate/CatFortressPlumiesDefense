extends Control
onready var animation_player = $AnimationPlayer

export(String, FILE, "*.tscn") var first_scene_path

func _ready():
	animation_player.play("FadeOutStartMenu")

func _on_PlayBtn_pressed():
	if first_scene_path:
		get_tree().change_scene(first_scene_path)


func _on_ExitBtn_pressed():
	get_tree().quit()
