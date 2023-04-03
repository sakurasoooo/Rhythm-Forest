extends Spatial

onready var maze_node = $Maze
onready var combat_scene = preload("res://managers/core/CombatScene.tscn")

var combat_node = null

var extra_unlock = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("combat_start", self, "_goto_combat_scene_deferred")
	Global.connect("combat_end", self, "_back_to_maze_deferred")


func _goto_combat_scene_deferred():
	call_deferred("_goto_combat_scene")


func _back_to_maze_deferred():
	call_deferred("_back_to_maze")


func _goto_combat_scene():
	InputManager.lock()
	remove_child(maze_node)
	combat_node = combat_scene.instance()
	add_child(combat_node)

	InputManager.unlock()
	while (InputManager.locked):
		extra_unlock += 1
		InputManager.unlock()


func _back_to_maze():
	remove_child(combat_node)
	combat_node.call_deferred("queue_free")
	add_child(maze_node)
	InputManager.unlock()
	for _i in range(extra_unlock):
		InputManager.lock()
