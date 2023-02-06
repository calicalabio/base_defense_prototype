extends Area2D

func _on_Base_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.begin_siege()
