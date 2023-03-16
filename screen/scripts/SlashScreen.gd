extends CanvasLayer

onready var credits_scene := preload("res://screen/Credits.tscn")

onready var start_button := $Canvas/VBoxContainer/StartButton
onready var setting_button := $Canvas/VBoxContainer/SettingButton


func _ready():
	start_button.grab_focus()
	var _ret = SettingScreen.connect("visibility_changed", self, "on_setting_close")


func _on_CreditButton_pressed():
	get_tree().get_root().add_child(credits_scene.instance())


func _on_SettingButton_pressed():
	SettingScreen.show_screen()


func on_setting_close():
	if SettingScreen.visible == false:
		setting_button.grab_focus()
