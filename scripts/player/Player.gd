extends Node2D

onready var moveable_parts = $Moveable
onready var bullet_spawn_position = $Moveable/BulletSpawnPosition
onready var draft_bullet = $Moveable/BulletDraft
onready var reload_timer = $ReloadTimer
onready var fire_rate_timer = $FireRateTimer
onready var ammo_bar = $Moveable/AmmoBar
onready var ammo_bar_tween = $Moveable/AmmoBarTween

var test_bullet = preload("res://scenes/projectiles/TestBullet.tscn")

var equipped_weapon = Pistol.new()
var ready_to_shoot : bool = true
var is_reloading : bool = false
var rounds_in_magazine : int = 0
var pressed_buttons = {
	"fire" : false,
	"reload" : false
}

func _init():
	rounds_in_magazine = equipped_weapon.magazine_size	


func _process(delta):
	moveable_parts.look_at(get_global_mouse_position())
	
	if ready_to_shoot and not is_reloading and Global.is_round_active:
		if Input.is_action_pressed("fire"):
			if equipped_weapon.fire_type == "auto":
				fire_weapon()
			elif equipped_weapon.fire_type == "semi" or equipped_weapon.fire_type == "limitless":
				if not pressed_buttons["fire"]:
					pressed_buttons["fire"] = true
					fire_weapon()
	
	if Input.is_action_just_released("fire"):
		pressed_buttons["fire"] = false


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("reload") and not pressed_buttons["reload"]:
		pressed_buttons["reload"] = true
		
		if not is_reloading and not rounds_in_magazine == equipped_weapon.magazine_size: 
			initiate_reload()
	
	if Input.is_action_just_released("reload"):
		pressed_buttons["reload"] = false			


func fire_weapon():
	var new_test_bullet = test_bullet.instance()			
	add_child(new_test_bullet)
	initialise_bullet(new_test_bullet)
	rounds_in_magazine -= 1
	ammo_bar.value = (float(rounds_in_magazine) / float(equipped_weapon.magazine_size)) * 100.0
	
	if rounds_in_magazine <= 0:
		initiate_reload()
	else:	
		if not equipped_weapon.fire_type == "limitless":
			ready_to_shoot = false 
			fire_rate_timer.set_wait_time(equipped_weapon.fire_rate)
			fire_rate_timer.start()
			#yield(get_tree().create_timer(equipped_weapon.fire_rate), "timeout")
			#ready_to_shoot = true		
		
		
func initialise_bullet(new_test_bullet : Node):
	new_test_bullet.global_position = bullet_spawn_position.global_position
	new_test_bullet.rotation_degrees = moveable_parts.rotation_degrees
	new_test_bullet.damage = equipped_weapon.damage


func initiate_reload():
	is_reloading = true
	reload_timer.set_wait_time(equipped_weapon.reload_time)
	reload_timer.start()
	ammo_bar_tween.interpolate_property(ammo_bar, "value", 0, 100, equipped_weapon.reload_time)
	ammo_bar_tween.start()
	
	
func _on_ReloadTimer_timeout() -> void:
	rounds_in_magazine = equipped_weapon.magazine_size
	ammo_bar.value = 100
	is_reloading = false
	

func _on_FireRateTimer_timeout() -> void:
	ready_to_shoot = true
