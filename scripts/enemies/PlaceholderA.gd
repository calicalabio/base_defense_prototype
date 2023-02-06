extends "res://scripts/enemies/Enemy.gd"


func _on_PlaceholderA_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
#		if event.pressed:
#			handle_clicked()
	pass


func _on_AttackTimer_timeout() -> void:
	try_attack()
