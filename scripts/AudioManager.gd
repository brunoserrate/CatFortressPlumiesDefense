extends Node

func _ready():
	var root = get_tree().get_root()
	connect_buttons(root)
	get_tree().connect("node_added", self, "_on_SceneTree_node_added")

func play_sound(sound: String, volume: float = 1.0, pitch: float = 1.0):
	var sound_instance = AudioStreamPlayer.new()
	var audio_stream = load(sound)
	var timer = Timer.new()

	if audio_stream is AudioStreamSample:
		audio_stream.loop_mode = AudioStreamSample.LOOP_NONE
	elif audio_stream is AudioStreamOGGVorbis:
		audio_stream.loop = false

	sound_instance.stream = audio_stream
	sound_instance.volume_db = volume
	sound_instance.pitch_scale = pitch

	timer.wait_time = audio_stream.get_length()
	timer.one_shot = true
	timer.connect("timeout", self, "clear_timer_audio", [timer, sound_instance])

	add_child(sound_instance)
	add_child(timer)

	sound_instance.play()
	timer.start()

func play_music(music: String, volume: float = 1.0, pitch: float = 1.0):
	var music_instance = AudioStreamPlayer.new()
	music_instance.stream = load(music)
	music_instance.volume_db = volume
	music_instance.pitch_scale = pitch
	music_instance.play()
	add_child(music_instance)
	music_instance.connect("finished", music_instance, "queue_free")

func stop_all_sounds():
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.queue_free()

		if child is Timer:
			child.queue_free()

func stop_sound(sound: String):
	for child in get_children():
		if child is AudioStreamPlayer and child.stream == load(sound):
			child.stop()
			child.queue_free()

func stop_music(music: String):
	for child in get_children():
		if child is AudioStreamPlayer and child.stream == load(music):
			child.stop()

func _on_SceneTree_node_added(node):
	if node is Button or node is TextureButton:
		connect_to_button(node)

func connect_buttons(root: Node):
	for child in root.get_children():
		if child is Button or child is TextureButton:
			child.connect("pressed", self, "_on_button_pressed")

		connect_buttons(child)

func connect_to_button(button):
	if !button.is_connected("pressed", self, "_on_button_pressed"):
		button.connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	play_sound("res://assets/Music/button.mp3")

func clear_timer_audio(timer_node, audio_node):
	timer_node.queue_free()
	audio_node.queue_free()
