extends Node

var locked = false

var _lock_count = 0

var forward_just_pressed  = 0 setget ,get_forward_just_pressed
var left_just_pressed = 0 setget  ,get_left_just_pressed
var right_just_pressed = 0 setget ,get_right_just_pressed

func _physics_process(delta):
	forward_just_pressed -= delta
	left_just_pressed -= delta
	right_just_pressed -= delta

func _unhandled_input(_event):
	if locked:
		return

	if Input.is_action_just_pressed("Forward"):
		forward_just_pressed = 0.1 + GameSetting.delay

		

	if Input.is_action_just_pressed("TurnLeft"):
		left_just_pressed = 0.1
		right_just_pressed = -1
	if Input.is_action_just_pressed("TurnRight"):
		left_just_pressed = -1
		right_just_pressed = 0.1



func set_as_handle():
	
	forward_just_pressed = -1
	left_just_pressed = -1
	right_just_pressed = -1


func get_forward_just_pressed():
	return forward_just_pressed

func get_left_just_pressed():
	return left_just_pressed

func get_right_just_pressed():
	return right_just_pressed

func lock():
	
	_lock_count = clamp(_lock_count + 1,0, 99)
	locked = true

func unlock():
	_lock_count = clamp(_lock_count - 1,0, 99)

	if _lock_count == 0:
		locked = false

func get_forward_just_pressed_elapsed():
	return  0.1 + GameSetting.delay - forward_just_pressed