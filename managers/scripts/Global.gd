extends Node

onready var disapper_fx := preload("res://screen/components/BeatBarDisappear.tscn")

signal camera_shake(amount)

signal beat_handled(delay)