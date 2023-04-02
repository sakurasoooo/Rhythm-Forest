extends Spatial

export(String, FILE, "*.res") var explosion_vfx
export(String, FILE, "*.tscn") var item_scene


func _on_Area_body_entered(body:Node):
	call_deferred("queue_free")
