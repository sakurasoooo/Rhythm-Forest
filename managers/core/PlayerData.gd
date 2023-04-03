extends Node

signal item_changed(slot)

var level: int = 1 setget , get_lv
var experience: int = 0 setget , get_exp

var max_health = 10

var health: int = 10 setget , get_health

var strength: int = 1 setget , get_strength
var intellegence: int = 1 setget , get_intellegence
var agile: int = 1 setget , get_agile
var luck: int = 1 setget , get_luck

var defence: int = 1 setget , get_defence

var axe: bool = false setget , has_axe

var floor_num: int = 1

var slot: Item = null

enum { FOREST, OCENE, LAVA }


func get_lv() -> int:
	return level


func get_exp() -> int:
	return experience


func get_health() -> int:
	return health


func apply_damage(value):
	health -= value


func get_strength() -> int:
	return strength


func get_intellegence() -> int:
	return intellegence


func get_agile() -> int:
	return agile


func get_luck() -> int:
	return luck


func get_defence() -> int:
	return defence


func set_strength(value) -> void:
	strength += value


func has_axe() -> bool:
	return axe


func add_axe():
	axe = true


func remove_axe():
	axe = false


func _get_next_exp():
	var x = level + 1
	return 25 * pow(x, 3) - 75 * pow(x, 2) + 100 * x


#add_item will diable all items
func add_item(_item):
	if slot:
		slot.disable_item()
		slot = null

	if slot == null:
		slot = _item
		_item.enable_item()
		emit_signal("item_changed", slot)


func remove_item():
	if slot:
		slot.disable_item()
		slot = null
		emit_signal("item_changed", slot)


func add_exp(value):
	experience += value

	while experience >= _get_next_exp():
		experience = _get_next_exp() - experience
		_updgrade()


func _updgrade():
	randomize()
	level += 1
	health += 1
	match randi() % 4:
		0:
			luck += 1
		1:
			strength += 1
		2:
			intellegence += 1
		3:
			agile += 1


func get_current_theme():
	if level >= 0 and level <= 10:
		return FOREST
	if level > 10 and level <= 20:
		return OCENE
	if level > 20 and level <= 30:
		return LAVA
	if level > 30:
		randomize()
		return randi() % 4
