extends Node


onready var animation_player = $AnimationPlayer


func _ready():
	var _ret = MusicManager.connect("beat",self,"_on_beat")






func _on_beat(_value):
	# print("beat")
	animation_player.play("Beat")
	animation_player.seek(0)

