extends Enemy

onready var health: int = data.max_health


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.connect("beat", self, "_on_beat")
	CombatManager.connect("player_attack", self, "_handle_attack")
	CombatManager.enemy_data = data


var just_beat = 0

var next_beat = 0.5

enum { IDLE, ATTACK }

var state = IDLE

var attack_pattern = [CombatManager.ACTION.IDLE,CombatManager.ACTION.ATTACK]

var motion_counter = attack_pattern.size()

func _on_beat(_value):
	
	match state:
		IDLE:
			CombatManager.enemy_action = CombatManager.ACTION.IDLE
			if motion_counter == 1:
				state = ATTACK
				motion_counter = attack_pattern.size()
			else:
				motion_counter -= 1
			
		ATTACK:
			CombatManager.enemy_action = attack_pattern[attack_pattern.size() - motion_counter]
			if motion_counter == 1:
				state = IDLE
				motion_counter = attack_pattern.size()
			else:
				motion_counter -= 1
	




	if CombatManager.enemy_action == CombatManager.ACTION.ATTACK:
		CombatManager.emit_signal("enemy_attack")
		_normal_attack()




func _physics_process(delta):
	just_beat -= delta
	next_beat -= delta

	if health <= 0:
		set_physics_process(false)
		call_deferred("_end_combat")


func _handle_attack():
	if CombatManager.enemy_action != CombatManager.ACTION.DEFENCE and CombatManager.enemy_action != CombatManager.ACTION.EVADE:
		if CombatManager.enemy_action == CombatManager.ACTION. COUNTER:
			CombatManager.emit_signal("enemy_attack")
			return
		randomize()
		var extra_rate = 1
		if rand_range(0, 100) >= ((100 - pow(PlayerData.get_agile(), 2)) - PlayerData.get_luck()):
			extra_rate = 2
			Global.emit_signal("camera_shake", 0.5)
		var player_damage = (
			(
				int(clamp(PlayerData.get_strength() - data.armor_defence, 0, 999))
				+ int(clamp(PlayerData.get_intellegence() - data.magic_defence, 0, 999))
			)
			* extra_rate
		)
		
		health = int(clamp( health - player_damage, 0, data.max_health))
		_hurt(player_damage)
		print(name + " " + str(health))


func _hurt(_value):
	var tween := create_tween()
	tween.tween_property($Sprite3D, "modulate", Color.red, 0.2)
	tween.tween_property($Sprite3D, "modulate", Color.white, 0.1)


func _end_combat():
	InputManager.lock()
	Global.emit_signal("camera_shake", 0.8)
	MusicManager.disconnect("beat", self, "_on_beat")
	CombatManager.enemy_data = null
	PlayerData.add_exp(data.experience)
	Global.emit_signal("combat_end")
	call_deferred("queue_free")

func _normal_attack():

	var tween := create_tween()
	tween.tween_property(self, "translation", _forward() / 2.0 * 10, 0.15).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_IN
	)
	tween.tween_property(self, "translation", -_forward() / 2.0 * 10, 0.1).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_OUT
	)

func _forward():
	return -(get_global_transform().basis.z)
