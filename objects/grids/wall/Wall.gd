extends MeshInstance



func _on_Area_body_entered(body:Node):
	call_deferred("queue_free")
