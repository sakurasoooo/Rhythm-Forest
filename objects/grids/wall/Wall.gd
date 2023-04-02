extends MeshInstance



func _on_Area_body_entered(body:Node):
	Global.emit_signal("camera_shake",0.5)
	call_deferred("queue_free")
