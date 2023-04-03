extends CanvasLayer

onready var back_button := $Panel/BackButton

onready var main_volume_slider = $Panel/VBoxContainer/VBoxContainer/HSlider

func _ready():
	visible = false;

	main_volume_slider.value = GameSetting.main_volume
	

func _on_BackButton_pressed():
	visible = false;

func hide_screen():
	visible = false;

func show_screen():
	back_button.grab_focus()
	visible = true

func _on_Setting_visibility_changed():
	pass





func _on_HSlider_value_changed(value:float):
	GameSetting.main_volume = value
