extends TextureRect



var copy

var shadow = false

var live_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_start")
	

func deferred_connection():
	Global.connect("beat_handled",self,"create_handled_deffered",[],CONNECT_ONESHOT)

func _start():
	if not shadow:
		call_deferred("add_shadow")
		
		#start
		var tween := create_tween()

		tween.tween_property(self,"rect_position",Vector2((OS.window_size.x - rect_size.x) / 2,15),0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE).from_current()
		tween.tween_callback(self,"create_exit_deffered")

func add_shadow():

	copy = self.duplicate()
	copy.shadow = true
	copy.flip_h = true
	get_parent().add_child(copy)

func _physics_process(_delta):
	if not shadow:
		live_time += _delta
		copy.rect_position = Vector2((OS.window_size.x - rect_size.x ) - rect_position.x,rect_position.y)

		if InputManager.get_forward_just_pressed() > 0 and live_time  > 0.2:
			create_handled_deffered()


func _dispose():
	call_deferred("queue_free")
	if copy:
		copy._dispose()

func create_exit_deffered():
	call_deferred("_create_exit")

func create_handled_deffered(_delay = 0):
	call_deferred("_create_handle")

func _create_exit():
	var vfx:TextureRect = Global.disapper_fx.instance()
	get_parent().add_child(vfx)
	vfx.rect_global_position = rect_global_position

	var vfx_copy:TextureRect = vfx.duplicate()
	get_parent().add_child(vfx_copy)
	vfx_copy.rect_global_position = copy.rect_global_position

	_dispose()

func _create_handle():
	var vfx:TextureRect = Global.disapper_fx.instance()
	vfx.success = true
	get_parent().add_child(vfx)
	vfx.rect_global_position = rect_global_position

	var vfx_copy:TextureRect = vfx.duplicate()
	vfx_copy.success = true
	get_parent().add_child(vfx_copy)
	vfx_copy.rect_global_position = copy.rect_global_position
	
	_dispose()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
