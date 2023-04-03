extends KinematicBody
class_name PlayerControllter

export(float) var speed = 2.0

onready var wall_raycast := $ForwardRay
onready var ground_raycast := $BottomRay

var just_beat = 0

var next_beat = 0.5

# var beat_pass: bool = false

enum STATE { MOVE, COMBAT }

export(STATE) var state := STATE.MOVE


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.connect("beat", self, "_on_beat")

	if state == STATE.COMBAT:
		CombatManager.connect("enemy_attack", self, "_handle_attack")


func _physics_process(delta):
	#Failure check
	# if InputManager.get_forward_just_pressed() > 0 and just_beat < delta:
	# 	beat_pass = true
	#AFTER Failure check

	# if InputManager.get_forward_just_pressed() > 0 and just_beat < 0:
	# 	just_pressed = 0.2
	match state:
		STATE.MOVE:
			just_beat -= delta
			next_beat -= delta
			move_state()
		STATE.COMBAT:
			combat_state()


func combat_state():
	if InputManager.get_left_just_pressed() >= 0 or InputManager.get_right_just_pressed() >= 0:
		InputManager.set_as_handle()
		CombatManager.player_action = CombatManager.ACTION.EVADE

	if InputManager.get_forward_just_pressed() >= 0:
		InputManager.set_as_handle()
		if CombatManager.player_action == CombatManager.ACTION.IDLE:
			CombatManager.player_action = CombatManager.ACTION.ATTACK


func move_state():
	if InputManager.get_forward_just_pressed() >= 0 and just_beat >= 0:
		var press_delay: float = (
			(
				InputManager.get_forward_just_pressed_elapsed()
				+ (just_beat - (0.05 + GameSetting.delay))
			)
			* 1000.0
		)
		Global.emit_signal("beat_handled", press_delay)

		InputManager.set_as_handle()
		_handled_just_beat()
		if wall_raycast.is_colliding():
			_move_bounce()
		else:
			_move_forward()

	if InputManager.get_left_just_pressed() > 0:
		InputManager.set_as_handle()
		rotation_degrees.y += 90.0

	if InputManager.get_right_just_pressed() > 0:
		InputManager.set_as_handle()
		rotation_degrees.y -= 90.0


func _on_beat(_value):
	
	match state:
		STATE.MOVE:
			_set_just_beat()
		STATE.COMBAT:
			if CombatManager.player_action == CombatManager.ACTION.ATTACK:
				CombatManager.emit_signal("player_attack")
				_normal_attack()


func _normal_attack():
	InputManager.lock()

	var tween := create_tween()
	tween.tween_property(self, "translation", _forward() / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_IN
	)
	tween.tween_property(self, "translation", -_forward() / 2.0 * speed, 0.1).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_OUT
	)
	tween.tween_callback(InputManager, "unlock")


func _set_just_beat():
	if just_beat < -(0.5 - (0.05 + GameSetting.delay)):
		var press_delay: float = -(0.5 - 0.05 + GameSetting.delay) * 1000.0
		Global.emit_signal("beat_handled", press_delay)

	just_beat = 0.05 + GameSetting.delay

	next_beat = 0.5


func _handled_just_beat():
	just_beat = -1


func _forward():
	return -(get_global_transform().basis.z)


func _move_forward():
	InputManager.lock()
	var tween := create_tween()
	tween.tween_property(self, "translation", _forward() / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_IN
	)
	tween.tween_property(self, "translation", _forward() / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_OUT
	)
	tween.tween_callback(InputManager, "unlock")
	tween.tween_callback(self, "_check_ground")


func _move_bounce():
	InputManager.lock()

	var tween := create_tween()
	tween.tween_property(self, "translation", _forward() / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_IN
	)
	tween.tween_callback(self, "_shake")
	tween.tween_property(self, "translation", -_forward() / 2.0 * speed, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_OUT
	)
	tween.tween_callback(InputManager, "unlock")


func _shake():
	Global.emit_signal("camera_shake", 0.3)


func _move_fall():
	InputManager.lock()
	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3.LEFT * 90, 0.2).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_IN
	)
	tween.tween_callback(Global, "emit_signal", ["change_map", true])
	Global.connect("change_map_end", self, "_fall_reset", [], CONNECT_ONESHOT)


func _idle():
	InputManager.lock()
	Global.emit_signal("change_map", false)
	Global.connect("change_map_end", self, "_idle_reset", [], CONNECT_ONESHOT)


func _fall_reset():
	_move_reset(true)


func _idle_reset():
	_move_reset()


func _move_reset(fall := false):
	if fall:
		Global.emit_signal("camera_shake", 0.8)
		Global.emit_signal("fall_damage")
		PlayerData.apply_damage(1)

	var tween := create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3(0, rotation_degrees.y, 0), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_IN
	)
	tween.tween_callback(InputManager, "unlock")

	PlayerData.floor_num += 1


func _check_ground():
	if ground_raycast.is_colliding():
		var area = ground_raycast.get_collider()
		if area.get_collision_layer_bit(6):
			_move_fall()
			return
		if area.get_collision_layer_bit(4):
			_idle()
			return


func _handle_attack():
	print("got attack")
	if CombatManager.player_action == CombatManager.ACTION.EVADE:
		return
	if rand_range(0, 100) >= ((100 - pow(PlayerData.get_agile(), 3)) - PlayerData.get_luck()):
		return

	PlayerData.apply_damage(CombatManager.enemy_data.damage)
	Global.emit_signal("got_damage")
