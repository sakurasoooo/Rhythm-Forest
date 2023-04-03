extends Item
class_name AxeItem

func enable_item():
	
	PlayerData.add_axe()
	PlayerData.set_strength(1)

func disable_item():
	PlayerData.remove_axe()
	PlayerData.set_strength(-1)
