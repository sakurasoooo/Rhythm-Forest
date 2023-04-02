extends TextureRect

var success = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var color

	if success:
		color = Color.green
	else:
		color = Color.red

	self_modulate = color

	#start
	var tween := create_tween()

	tween.tween_property(self,"self_modulate", Color(color.r,color.g,color.b,0) ,0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(self,"_dispose")


func _dispose():
	queue_free()

