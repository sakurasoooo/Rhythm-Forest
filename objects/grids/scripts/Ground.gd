extends CSGMesh


# onready var _material = self.get_material(0)

var count:int = 0;

func _ready():
	var _ret = MusicManager.connect("beat",self,"_on_beat")


func _on_beat(_value):
	if ((int(translation.z) + int(translation.x)) / 2) % 2 == 0:
		if count == 0:
			set_mesh_color(Color.white)
		if count == 1:
			set_mesh_color(Color.violet)
	else:
		if count == 1:
			set_mesh_color(Color.white)
		if count == 0:
			set_mesh_color(Color.violet)

	count+=1;
	if count > 1:
		count = 0;
	


func set_mesh_color(color: Color):
	material.albedo_color = color
	# self.set_material(0, material)
	