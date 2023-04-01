extends Node

#9 路
#0 不可通过墙体
#1 空地
#2 可摧毁墙体
#3 起点
#4 终点
#5 宝箱
#6 陷阱
#7 怪物
#8 金宝箱

# STONE: Represents a stone tile or object.
# PATH: Represents a path tile or object.
# WALL: Represents a wall tile or object.
# PLAYER: Represents the player character or object.
# STAIR: Represents a stair or portal object that allows the player to move to a different level or area.
# ITEM: Represents an item or power-up object that the player can collect.
# TRAP: Represents a trap or hazard object that the player must avoid or disarm.
# MONSTER: Represents a monster or enemy object that the player must fight or avoid.
# CHEST: Represents a treasure chest or object that the player can open to obtain items or rewards.
enum { STONE, EMPTY, WALL, PLAYER, STAIR, ITEM, TRAP, MONSTOR, CHEST, PATH }

var random = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func new_map_arr(size: int) -> Array:
	randomize()
	random.randomize()
	var x = size
	var arr = generate_2d_array(x)

	var chest = insert_into_2d_array(5,arr)
	var chest2 = insert_into_2d_array(8,arr)
	var end =  insert_into_2d_array(4,arr)
	var start =  insert_into_2d_array(3,arr)

	cover_2d_array_boundary_with_x(0,arr)

	dfs_2d_array(start, end, arr)
	dfs_2d_array(start, chest, arr)

	generate_room(chest,arr)
	generate_room(chest2,arr)
	generate_room(end,arr)

	remove_path(arr)

	generate_monster(chest2,arr)
	generate_monster(end,arr)

	generate_safe_room(start,arr)
	for row in arr:
		print(row)
	return arr


func generate_2d_array(x: int) -> Array:
	var arr = []
	for _i in range(x):
		var row = []
		for _j in range(x):
			row.append(WALL)
		arr.append(row)
	return arr


func insert_into_2d_array(x: int, arr: Array) -> Vector2:
	for _limit in range(len(arr) * len(arr)):
		var i = random.randi_range(1, len(arr) - 2)
		var j = random.randi_range(1, len(arr) - 2)
		if arr[i][j] == WALL:
			arr[i][j] = x
			return Vector2(i,j)
	return Vector2(0,0)


func cover_2d_array_boundary_with_x(x: int, arr: Array):
	for i in range(len(arr)):
		for j in range(len(arr[0])):
			if i == 0 or i == len(arr) - 1 or j == 0 or j == len(arr[0]) - 1:
				arr[i][j] = x


func border_check(i: int, j: int, arr: Array):
	var rows = len(arr)
	var cols = len(arr[0])
	return not (i < 0 or i >= rows or j < 0 or j >= cols)


func dfs_2d_array(start: Vector2, end: Vector2, arr: Array):
	var rows = len(arr)
	var cols = len(arr[0])
	var visited = []
	for _c in range(rows):
		var visit = []
		for _v in range(cols):
			visit.append(false)
		visited.append(visit)

	dfs_helper(end, arr, int(start[0]), int(start[1]), 0, visited.duplicate(true))


func dfs_helper(
	end: Vector2, arr: Array, i: int, j: int, deep: int, visited: Array
):
	var rows = len(arr)
	var directions = [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]
	deep = deep + 1

	#判断当前节点是否在图的边界内
	if not border_check(i, j, arr):
		return -1
	#判断当前节点是否已经被访问过 最后判断当前节点的值是否为墙
	if visited[i][j]:
		return -1

	#设置当前节点被访问过
	visited[i][j] = true
	#过于于密集就停止搜索
	if _adjacents(i, j, arr, visited) > 0:
		return -1

	#如果当前节点是寻找的终点返回True
	if Vector2(i, j) == end:
		return 1
	#如果是不可摧毁的墙 返回
	if arr[i][j] == STONE:
		return 0
	#到达指定深度停止搜索 并 生产陷阱
	if deep > (rows - 1) * 3:
		arr[i][j] = TRAP
		return 2
	directions.shuffle()

	for _count in range(4):
		var d = directions[len(directions) - 1]
		if border_check(i + d[0], j + d[1], arr):
			if arr[i + d[0]][j + d[1]] == PATH:
				var temp = directions.pop_back()
				directions.push_front(temp)
	for d in directions:
		var value = dfs_helper(end, arr, i + d[0], j + d[1], deep, visited.duplicate(true))
		if value >= 1:
			if arr[i][j] == WALL:
				arr[i][j] = PATH
			return 1

	return -1


func _adjacents(i: int, j: int, arr:Array, visited:Array):
	var count = 0
	var diagonals = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	for d in diagonals:
		if border_check(i + d[0], j + d[1], arr):
			if (visited[i + d[0]][j + d[1]]) and (visited[i][j + d[1]]) and (visited[i + d[0]][j]):
				count += 1
	return count


#在周围生成8个1
func generate_monster(pos:Vector2, arr:Array):
	var diagonals = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	var i = pos[0]
	var j = pos[1]
	for d in diagonals:
		if border_check(i + d[0], j + d[1], arr):
			if arr[i + d[0]][j + d[1]] == EMPTY:
				var random_number = random.randi_range(1, 4)
				if random_number == 1:
					arr[i + d[0]][j + d[1]] = MONSTOR
					return
			#没有偷懒
			if arr[i][j + d[1]] == EMPTY:
				var random_number = random.randi_range(1, 4)
				if random_number == 1:
					arr[i][j + d[1]] = MONSTOR
					return
			if arr[i + d[0]][j] == EMPTY:
				var random_number = random.randi_range(1, 4)
				if random_number == 1:
					arr[i + d[0]][j] = MONSTOR
					return


func generate_room(pos:Vector2, arr:Array):
	var diagonals = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	var i = pos[0]
	var j = pos[1]

	for d in diagonals:
		if border_check(i + d[0], j + d[1], arr):
			if arr[i + d[0]][j + d[1]] == WALL:
				arr[i + d[0]][j + d[1]] = EMPTY
			#没有偷懒
			if arr[i][j + d[1]] == WALL:
				arr[i][j + d[1]] = EMPTY
			if arr[i + d[0]][j] == WALL:
				arr[i + d[0]][j] = EMPTY


func generate_safe_room(pos:Vector2, arr:Array):
	var diagonals = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	var i = pos[0]
	var j = pos[1]
	for d in diagonals:
		if border_check(i + d[0], j + d[1], arr):
			if arr[i + d[0]][j + d[1]] == MONSTOR:
				arr[i + d[0]][j + d[1]] = EMPTY
			#没有偷懒
			if arr[i][j + d[1]] == MONSTOR:
				arr[i][j + d[1]] = EMPTY
			if arr[i + d[0]][j] == MONSTOR:
				arr[i + d[0]][j] = EMPTY


#将所有9替换为1
func remove_path(arr:Array):
	for i in range(len(arr)):
		for j in range(len(arr[i])):
			if arr[i][j] == PATH:
				arr[i][j] = EMPTY
