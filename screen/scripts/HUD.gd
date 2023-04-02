extends CanvasLayer

export(NodePath) var player_path

onready var beat_bar_path = preload("res://screen/components/BeatBar.tscn")

onready var beat_anchor = $Control/Anchor


onready var delay_label = $Control/Anchor/Label

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.connect("beat",self,"_on_beat")
	Global.connect("beat_handled",self,"change_delay_text")

	if player_path:
		player = get_node(player_path)
		if(player):
			print(player.name)


func _on_beat(_value):
	call_deferred("create_bar")


func create_bar():
	var bar = beat_bar_path.instance()
	beat_anchor.add_child(bar)
	bar.rect_position = Vector2((OS.window_size.x - bar.rect_size.x) / 2 + 100, bar.rect_position.y - 50)


func change_delay_text(value):
	if abs(value) < 50:
		delay_label.set("custom_colors/font_color", Color.green)
	elif abs(value) < 100:
		delay_label.set("custom_colors/font_color", Color.yellow)
	else:
		delay_label.set("custom_colors/font_color", Color.red)
	delay_label.text = "{delay} ms".format({"delay": str(int(value))})
	
