extends CanvasLayer

export(NodePath) var player_path
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)

	if(player_path):
		print(player.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
