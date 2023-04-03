extends Spatial

onready var slime_scene = preload("res://objects/enemies/Slime.tscn")

onready var enemy_center = $EenemyPoint/Center

var extra_unlock = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	InputManager.unlock()
	while (InputManager.locked):
		extra_unlock += 1
		InputManager.unlock()


	if PlayerData.get_current_theme() == PlayerData.FOREST:
		var emeny = slime_scene.instance()
		enemy_center.add_child(emeny)

		
