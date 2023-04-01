extends MeshInstance


# onready var _material = self.get_material(0)

var count:int = 0;
var disco_mat:Material

func _ready():
	var _ret = MusicManager.connect("beat",self,"_on_beat")
	var mat = get_active_material(0)
	disco_mat = mat.next_pass
	# disco_mat = SpatialMaterial.new()
	# disco_mat.params_blend_mode = SpatialMaterial.BLEND_MODE_MUL
	# mat.next_pass = disco_mat
	# disco_mat.resource_local_to_scene = true
	
	

func _on_beat(_value):
	if ((int(translation.z) + int(translation.x)) / 2) % 2  == 0:
		if count == 0:
			set_mesh_color(Color.white)
		if count == 1:
			set_mesh_color(Color.violet)
	# else:
	# 	if count == 1:
	# 		set_mesh_color(Color.white)
	# 	if count == 0:
	# 		set_mesh_color(Color.green)

	count+=1;
	if count > 1:
		count = 0;
	


func set_mesh_color(color: Color):
	disco_mat.albedo_color = color
	# self.set_material(0, material)
	
func axis_to_grid(pos:Vector3):
	return Vector2((pos.x - 1) / 2 ,( pos.z - 1) / 2)

func grid_to_axis(pos:Vector2):
	return Vector3(pos[0] * 2 + 1 , 1 , pos[1] * 2 + 1)
