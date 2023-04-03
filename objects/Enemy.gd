extends KinematicBody

export(float) var speed = 2.0

onready var wall_raycast := $ForwardRay
onready var ground_raycast := $BottomRay


func _on_Area_body_entered(body: Node):
	MusicManager.disconnect("beat", self, "_on_beat")
	# InputManager.lock()
	Global.emit_signal("combat_start")

	call_deferred("queue_free")


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.connect("beat", self, "_on_beat")


func _on_beat(_value):
	if wall_raycast.is_colliding():
		call_deferred("_move_rotate")
	else:
		call_deferred("_move_forward")


func _move_forward():
	if is_inside_tree():
		var tween := create_tween()
		if tween:
			tween.tween_property(self, "translation", _forward() / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
				Tween.EASE_IN
			)
			tween.tween_property(self, "translation", _forward() / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
				Tween.EASE_OUT
			)


func _move_rotate():
	randomize()

	var rng = randi() % 6
	var degree = 0
	if rng == 0:
		degree = 45
	elif rng == 1:
		degree = -45
	elif rng == 2 or rng == 4:
		degree = 90
	elif rng == 3 or rng == 5:
		degree = -90

	if is_inside_tree():
		var tween := create_tween()
		if tween:
			tween.tween_property(self, "global_rotation", Vector3.UP * deg2rad(degree) / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
				Tween.EASE_IN
			)
			tween.tween_property(self, "global_rotation", Vector3.UP * deg2rad(degree) / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
				Tween.EASE_OUT
			)


func _forward():
	return -(get_global_transform().basis.z)
