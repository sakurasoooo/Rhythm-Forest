extends Spatial
#Map control

onready var player := get_node("%Player")
onready var map_root := self

#loading WAIT
onready var empty_grid := preload("res://objects/grids/bases/BaseGround.tscn")
onready var stone_grid := preload("res://objects/grids/bases/BaseGroundwSolid.tscn")
onready var wall_grid := preload("res://objects/grids/bases/BaseGroundwWall.tscn")
onready var stair_grid := preload("res://objects/grids/bases/BaseNextLevel.tscn")
onready var	void_trap_grid := preload("res://objects/grids/bases/BaseVoid.tscn")
onready var	water_trap_grid := preload("res://objects/grids/bases/BaseWater.tscn")
onready var gold_chest_grid := preload("res://objects/grids/bases/BaseGroundwGoldChest.tscn")
onready var wood_chest_grid := preload("res://objects/grids/bases/BaseGroundwWoodChest.tscn")

onready var enemy_scene := preload("res://objects/Enemy.tscn")

var map = []

enum { STONE, EMPTY, WALL, PLAYER, STAIR, ITEM, TRAP, MONSTOR, CHEST, PATH }

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("change_map",self,"change_map")

func next_level():
	clean_map()
	var new_map = SceneManager.new_map_arr(15)
	var row = len(new_map)
	var col = len(new_map[0])
	map.resize(row)

	for i in range(row):
		var row_map = []
		row_map.resize(col)
		for j in range(col):
			match new_map[i][j]:
				STONE:
					var new_grid = stone_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("stone")
				EMPTY:
					var new_grid = empty_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("empty")
				WALL:
					var new_grid = wall_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("wall")
				PLAYER:
					var new_grid = empty_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					#add player
					player.translation = new_grid.translation
					# print("player")
				STAIR:
					var new_grid = stair_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("STAIR")
				ITEM:
					var new_grid = wood_chest_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("Item")
				TRAP:
					var new_grid = void_trap_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("trap")
				MONSTOR:
					var new_grid = empty_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					#add Monster
					var new_monster = enemy_scene.instance()
					new_grid.add_child(new_monster)
					new_monster.translation =  Vector3.ZERO
					print("trap")
				CHEST:
					var new_grid = gold_chest_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("Chest")
				_:
					var new_grid = stone_grid.instance()
					map_root.add_child(new_grid)
					row_map[j] = new_grid
					new_grid.translation = grid_to_axis(Vector2(i,j))
					# print("stone")
		map[i] = (row_map)


func clean_map():
	for child in get_children():
		child.call_deferred("queue_free")

	map.clear()
	



func axis_to_grid(pos:Vector3):
	return Vector2((pos.x - 1) / 2 + 1 ,( pos.z - 1) / 2 + 1)

func grid_to_axis(pos:Vector2):
	return Vector3((pos[0] + 1) * 2 - 1 , 0 , (pos[1] + 1) * 2 - 1)


func change_map(fall):
	if fall:
		fall_next_level_trasition()
	else:
		next_level_trasition()

func fall_next_level_trasition():
	Global.emit_signal("change_map_start")
	var tween = create_tween()
	tween.tween_property(self,"translation",Vector3.UP * 10, 3).as_relative()
	tween.tween_property(self,"translation",Vector3.DOWN * 20, 0).as_relative()
	tween.tween_callback(self,"next_level")
	tween.tween_property(self,"translation",Vector3.ZERO, 1).set_delay(1)
	tween.tween_callback(Global,"emit_signal",["change_map_end"])

func next_level_trasition():
	Global.emit_signal("change_map_start")
	var tween = create_tween()
	tween.tween_callback(self,"next_level").set_delay(2)
	tween.tween_callback(Global,"emit_signal",["change_map_end"]).set_delay(1)

