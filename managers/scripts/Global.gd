extends Node

onready var disapper_fx := preload("res://screen/components/BeatBarDisappear.tscn")

signal camera_shake(amount)

signal beat_handled(delay)


signal change_map(fall)

signal change_map_start()

signal change_map_end()

signal fall_damage()
signal got_damage()

signal combat_start()

signal combat_end()