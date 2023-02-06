extends Area2D

var speed : int = 650
var damage : float = 100
var hit_enemy : bool = false

func _physics_process(delta: float) -> void:
	var direction = Vector2(1, 0).rotated(rotation)	
	global_position += speed * direction * delta	

func destroy():
	queue_free()

func _on_ExpiryTimer_timeout() -> void:
	destroy()

func _on_TestBullet_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and not hit_enemy:
		hit_enemy = true
		area.take_damage(damage)
		destroy()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	destroy()
