extends KinematicBody



# Called when the node enters the scene tree for the first time.
func _ready():
	var _ret = MusicManager.connect("beat",self,"_on_beat")

var just_pressed = 0;
var just_beat = 0;

var beat_pass: bool = false

func _physics_process(delta):
	if just_pressed >0 and  just_pressed < delta:
		beat_pass = true

	just_pressed -= delta
	just_beat -= delta


	if Input.is_action_just_pressed("Forward") and just_beat < 0:
		just_pressed = 0.2
	
	if just_pressed >= 0 and just_beat >= 0 and not beat_pass:
		just_pressed = -1
		just_beat = -1
		var tween = get_tree().create_tween()
		tween.tween_property(self, "translation", translation + forward() * 2, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)

func _unhandled_input(event):
	if Input.is_action_just_pressed("TurnLeft"):
		rotation_degrees.y += 90.0
	if Input.is_action_just_pressed("TurnRight"):
		rotation_degrees.y -= 90.0


func _on_beat(_value):
	if not beat_pass:
		just_beat = 0.20
	beat_pass = false


func forward():
	return -(get_global_transform().basis.z)
