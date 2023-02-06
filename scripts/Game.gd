extends Node2D

onready var round_timer = $RoundTimer

var hud : Node = null
var enemies : Node = null

var current_round : int = 1

var player_health : float = 100.0
var owned_currency : int = 0
var kill_count : int = 0
var click_damage : float = 50.0
var is_waiting_for_enemies_to_die : bool = false

func _ready() -> void:
	Global.rng.randomize()
	hud = $HUD
	enemies = $Enemies
	
	round_timer.connect("timeout", self, "try_end_round")
	hud.connect("start_round", self, "start_round")
	enemies.connect("enemy_clicked", self, "handle_clicked_enemy")
	enemies.connect("enemy_died", self, "handle_dead_enemy")
	enemies.connect("enemy_attacking", self, "handle_enemy_attacking")
	enemies.connect("all_enemies_dead", self, "end_round")
	
func _process(_delta):
	if Global.is_round_active and not is_waiting_for_enemies_to_die:
		hud.update_round_time(round_timer.get_time_left())

func start_round():	
	Global.is_round_active = true
	hud.setup_active_round_hud()
	round_timer.start()	
	enemies.start_spawner(current_round)

func try_end_round():
	if enemies.are_all_enemies_dead():
		end_round()
	else:
		is_waiting_for_enemies_to_die = true
		enemies.stop_spawner()
		enemies.start_checking_for_no_enemies()
		hud.set_round_time_label("Kill the remaining enemies!")

func end_round():
	is_waiting_for_enemies_to_die = false
	Global.is_round_active = false
	hud.setup_inactive_round_hud()
	enemies.stop_spawner()
	current_round += 1
	hud.update_round_number(current_round)

func handle_clicked_enemy(enemy_instance : Node):
	enemy_instance.take_damage(click_damage)
	
func handle_dead_enemy(enemy_worth : int):
	owned_currency += enemy_worth
	kill_count += 1
	hud.update_currency(owned_currency)
	hud.update_kill_count(kill_count)

func handle_enemy_attacking(power : float):
	player_health -= power
	hud.update_player_hp(player_health)
