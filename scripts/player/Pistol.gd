extends Weapon

class_name Pistol

func _init() -> void:
	damage = 10.0
	fire_rate = 0.15
	fire_type = "limitless"
	magazine_size = 8
	reload_time = 1.0
