extends Spatial

export(Resource) var item_res

func _ready():
	if item_res:
		$AnimatedSprite3D.frames = item_res.item_animation

func _on_Area_body_entered(body:Node):
	
	PlayerData.add_item(item_res)
	call_deferred("queue_free")


