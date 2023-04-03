extends Node

enum ACTION { IDLE, EVADE, ATTACK, DEFENCE, COUNTER }

var player_action: int = ACTION.IDLE

var enemy_action: int = ACTION.IDLE

var enemy_data: EnemyData = null

signal player_attack

signal enemy_attack


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.connect("beat", self, "_on_beat")


func _on_beat(_value):
	call_deferred("reset_actions_flag")


func reset_actions_flag():
	player_action = ACTION.IDLE
	enemy_action = ACTION.IDLE
