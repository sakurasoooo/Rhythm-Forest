extends Spatial

onready var slime_scene = preload("res://objects/enemies/Slime.tscn")

onready var enemy_center = $EenemyPoint/Center


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if PlayerData.get_current_theme() == PlayerData.FOREST:
		var emeny = slime_scene.instance()
		enemy_center.add_child(emeny)
	elif PlayerData.get_current_theme() == PlayerData.OCENE:
		var emeny = slime_scene.instance()
		enemy_center.add_child(emeny)
	elif PlayerData.get_current_theme() == PlayerData.LAVA:
		var emeny = slime_scene.instance()
		enemy_center.add_child(emeny)
	else:
		var emeny = slime_scene.instance()
		enemy_center.add_child(emeny)
		
