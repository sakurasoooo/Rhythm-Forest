extends Node

var level:int = 1  setget , get_lv
var experience:int = 0 setget , get_exp

var health:int = 0 setget , get_health

var strength:int = 1 setget , get_strength
var intellegence:int  = 1 setget , get_intellegence
var agile:int = 1 setget  , get_agile
var luck:int  = 1  setget, get_luck

var axe:bool = false setget , has_axe

func get_lv()-> int:
	return level

func get_exp()-> int:
	return experience

func get_health()-> int:
	return health

func get_strength()-> int:
	return strength

func get_intellegence()-> int:
	return intellegence

func get_agile()-> int:
	return agile

func get_luck() -> int:
	return luck

func has_axe() -> bool:
	return axe


func _get_next_exp():
	var x = level + 1
	return 25 * pow(x,3) - 75 * pow(x,2) + 100 * x

