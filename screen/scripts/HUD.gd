extends CanvasLayer

# export(NodePath) var player_path

onready var beat_bar_path = preload("res://screen/components/BeatBar.tscn")

onready var beat_anchor = $Control/Anchor

onready var delay_label = $Control/Anchor/Label

onready var item_img = $Control/DataBG/Item

onready var fall_anim = $Control/Hurt/AnimationPlayer

onready var load_trasiton = $Control/Trans

onready var floor_text = $Control/Floor

onready var level_text = $Control/DataBG/Data/HFlowContainer/LV

onready var exp_text = $Control/DataBG/Data/HFlowContainer/EXP

onready var str_text = $Control/DataBG/Data/HFlowContainer2/STR

onready var int_text = $Control/DataBG/Data/HFlowContainer3/INT

onready var agl_text = $Control/DataBG/Data/HFlowContainer4/AGL

onready var luc_text = $Control/DataBG/Data/HFlowContainer5/LUC

onready var def_text = $Control/DataBG/Data/HFlowContainer6/DEF

# var player


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.connect("beat", self, "_on_beat")
	Global.connect("beat_handled", self, "change_delay_text")
	PlayerData.connect("item_changed", self, "change_item_img")
	Global.connect("fall_damage", self, "get_hurt")
	Global.connect("got_damage", self, "get_hurt")

	Global.connect("change_map", self, "start_show_load_transition")
	Global.connect("change_map_end", self, "start_hide_load_transition")

	# if player_path:
	# 	player = get_node(player_path)
	# 	if(player):
	# 		print(player.name)


func _on_beat(_value):
	call_deferred("create_bar")


func create_bar():
	var bar = beat_bar_path.instance()
	beat_anchor.add_child(bar)
	bar.rect_position = Vector2(
		(OS.window_size.x - bar.rect_size.x) / 2 + 100, bar.rect_position.y - 50
	)


func change_delay_text(value):
	if abs(value) < 50:
		delay_label.set("custom_colors/font_color", Color.green)
	elif abs(value) < 100:
		delay_label.set("custom_colors/font_color", Color.yellow)
	else:
		delay_label.set("custom_colors/font_color", Color.red)
	delay_label.text = "{delay} ms".format({"delay": str(int(value))})


func change_item_img(item):
	print("item changed")
	if item:
		item_img.texture = item.item_icon
	else:
		item_img.texture = null


func get_hurt():
	fall_anim.play("Hurt")


func start_show_load_transition(fall):
	if not fall:
		var tween := create_tween()
		tween.tween_property(
			load_trasiton,
			"modulate",
			Color(load_trasiton.modulate.r, load_trasiton.modulate.g, load_trasiton.modulate.b, 1),
			1
		)


func start_hide_load_transition():
	var tween := create_tween()
	tween.tween_property(
		load_trasiton,
		"modulate",
		Color(load_trasiton.modulate.r, load_trasiton.modulate.g, load_trasiton.modulate.b, 0),
		1
	)


func _process(_delta):
	floor_text.text = "FLOOR {number}".format({"number": str(PlayerData.floor_num)})

	level_text.text = "LV:{number}".format({"number": str(PlayerData.get_lv())})

	exp_text.text = "EXP:{current}/{max}".format(
		{"current": str(PlayerData.get_exp()), "max": str(PlayerData._get_next_exp())}
	)

	str_text.text = "STR:{number}".format({"number": str(PlayerData.get_strength())})

	int_text.text = "INT:{number}".format({"number": str(PlayerData.get_intellegence())})

	agl_text.text = "AGL:{number}".format({"number": str(PlayerData.get_agile())})

	luc_text.text = "LUC:{number}".format({"number": str(PlayerData.get_luck())})

	def_text.text = "DEF:{number}".format({"number": str(PlayerData.get_defence())})
