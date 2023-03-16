extends CanvasLayer

onready var back_button := $Panel/BackButton


func _ready():
	visible = false;
	

func _on_BackButton_pressed():
	visible = false;

func hide_screen():
	visible = false;

func show_screen():
	back_button.grab_focus()
	visible = true

func _on_Setting_visibility_changed():
	pass
