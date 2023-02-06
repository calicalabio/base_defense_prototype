extends Area2D

func _input(event):
	if event is InputEventMouseMotion:
		self.global_position = get_global_mouse_position()
		
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			var clicked_areas = self.get_overlapping_areas()
			var clicked_enemies = []
			
			for area in clicked_areas:
				if area.is_in_group("enemy"):
					clicked_enemies.append(area)
					
			if clicked_enemies.size() >= 1:
				var front_enemy : Node = null
				var highest_z_index = -9000
				
				for enemy in clicked_enemies:
					if enemy.z_index > highest_z_index:
						front_enemy = enemy
						highest_z_index = front_enemy.z_index
					
				front_enemy.handle_clicked()
			
