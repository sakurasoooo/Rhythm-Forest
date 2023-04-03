extends Spatial

export(bool) var gold_chest = false

export(String, FILE, "*.tscn") var explosion_vfx
export(String, FILE, "*.tscn") var item_scene
onready var item  = preload("res://objects/item/Axe.tscn")

onready var area = $Area


func _on_Area_body_entered(body:Node):
	

	yield(area,"body_exited")
	# area.monitoring = false

	if item_scene:
		call_deferred("create_item")
	else:
		if gold_chest:
			randomize()
			if rand_range(0,10) >= 5:
				call_deferred("create_random_item")
		else:
			call_deferred("create_random_normal_item")
				

	call_deferred("queue_free")


func create_item():
	var new_item = load(item_scene).instance()
	get_parent().add_child(new_item)
	new_item.global_translation = global_translation

func create_random_item():
	var new_item = item.instance()
	get_parent().add_child(new_item)
	new_item.global_translation = global_translation


func create_random_normal_item():
	var new_item = item.instance()
	get_parent().add_child(new_item)
	new_item.global_translation = global_translation