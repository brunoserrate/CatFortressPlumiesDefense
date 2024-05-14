extends Node

func _ready():
	get_tree().paused = false

func togglePause():
	get_tree().paused = not get_tree().paused

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false
