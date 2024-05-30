extends Node

func play_sound(sound: String, volume: float = 1.0, pitch: float = 1.0) -> void:
	var sound_instance = AudioStreamPlayer.new()
	sound_instance.stream = load(sound)
	sound_instance.volume_db = volume
	sound_instance.pitch_scale = pitch
	sound_instance.play()
	add_child(sound_instance)

func play_music(music: String, volume: float = 1.0, pitch: float = 1.0) -> void:
	var music_instance = AudioStreamPlayer.new()
	music_instance.stream = load(music)
	music_instance.volume_db = volume
	music_instance.pitch_scale = pitch
	music_instance.play()
	add_child(music_instance)

func stop_all_sounds() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()

func stop_sound(sound: String) -> void:
	for child in get_children():
		if child is AudioStreamPlayer and child.stream == load(sound):
			child.stop()

func stop_music(music: String) -> void:
	for child in get_children():
		if child is AudioStreamPlayer and child.stream == load(music):
			child.stop()
