extends CanvasLayer

onready var credit_list = $Canvas/Container

export(int) var speed := 40
var key_pressed: = false

func _process(delta):
	# exit
	if credit_list.rect_position.y + credit_list.rect_size.y < 0:
		call_deferred("queue_free")

	var scroll_speed = speed
	if(key_pressed):
		scroll_speed = speed * 10
	

	credit_list.rect_position.y -= delta * scroll_speed



func _input(event):
	key_pressed = event.is_pressed()
	get_tree().set_input_as_handled()
