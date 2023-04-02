extends Node

var main_volume := 90.0 setget _set_main_volume, _get_main_volume
var input_delay := 15

var audio_delay := 0

var graphic_delay := 0

var delay:float = 0.05

func _set_main_volume(value):
	main_volume = value
	if value > 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"), 36 * (value / 100.0) - 36
		)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"), 36 * (value / 100.0) - 36
		)


func _get_main_volume():
	return main_volume
