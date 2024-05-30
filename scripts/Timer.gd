extends Label
onready var timer_label = $"."
var time = 0

func _ready():
	timer_label.text = "00:00"

func _process(delta):
	time += delta

	var minutes = int(time / 60)
	var seconds = int(time) % 60

	timer_label.text = str(int(minutes)).pad_zeros(2) + ":" + str(int(seconds)).pad_zeros(2)
