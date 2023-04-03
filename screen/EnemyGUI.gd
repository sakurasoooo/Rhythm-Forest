extends Spatial

onready var progressive_bar = $Viewport/HUD/Panel/ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if CombatManager.enemy_data:
		progressive_bar.value = (float(CombatManager.enemy_health) / float(CombatManager.enemy_data.max_health))  * 100.0