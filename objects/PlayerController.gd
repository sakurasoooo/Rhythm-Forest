extends KinematicBody



# Called when the node enters the scene tree for the first time.
func _ready():
	var _ret = MusicManager.connect("beat",self,"_on_beat")

var pressed = 0;

func _process(delta):
	pressed -= delta
	if Input.is_action_just_pressed("Forward"):
		print("pressed")
		pressed = 0.5

# func _unhandled_input(event):
# 	if Input.is_action_just_pressed("TurnLeft"):
# 		rotation_degrees.y += 90.0
# 	if Input.is_action_just_pressed("TurnRight"):
# 		rotation_degrees.y -= 90.0


func _on_beat(_value):
	if pressed > 0:
		pressed = 0
		translation += Vector3.FORWARD
