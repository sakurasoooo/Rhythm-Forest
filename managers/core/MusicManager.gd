extends Node

# warning-ignore-all:UNUSED_SIGNAL
signal beat(count)
var beat_type := 4
var beat_count := 0 setget _set_beat, _get_beat

onready var music_player = $MusicPlayer

onready var main_track = $MainTrack
onready var instrument1_track = $Instrument1Track

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func jump_to(seconds: float):
	music_player.seek(seconds, true)


func _set_beat(value: int):
	beat_count += value
	if beat_count >= beat_type:
		beat_count = 0


func _get_beat():
	return beat_count


func one_beat():
	beat_count += 1
	emit_signal("beat", beat_count)
