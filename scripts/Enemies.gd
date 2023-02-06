extends Node

signal enemy_clicked(enemy_instance)
signal enemy_died(worth)
signal enemy_attacking(power)
signal all_enemies_dead()

onready var spawn_timer = $EnemySpawnTimer
onready var enemy_pool = $EnemyPool
onready var spawn_position = $SpawnPosition
onready var no_enemies_checker = $NoEnemiesCheckerTImer
onready var enemy_list = $ActiveEnemyList

func _ready() -> void:
	spawn_timer.connect("timeout", self, "spawn_enemy")
	no_enemies_checker.connect("timeout", self, "check_for_no_enemies")

func start_spawner(wave_number : int):
	spawn_enemy()
	spawn_timer.start()

func stop_spawner():
	spawn_timer.stop()

func spawn_enemy():
	var new_enemy = enemy_pool.get_enemy_instance_from_pool("res://scenes/enemies/PlaceholderA.tscn")
	var random_spawn_height : float = Global.rng.randf_range(spawn_position.global_position.y - 30.0, spawn_position.global_position.y + 30.0)
	new_enemy.global_position = Vector2(spawn_position.global_position.x, random_spawn_height)	
	new_enemy.z_index = random_spawn_height
	enemy_list.add_child(new_enemy)
	new_enemy.initialise_enemy()

func remove_all_enemies():
	pass

func handle_clicked_enemy(enemy_instance : Node):
	emit_signal("enemy_clicked", enemy_instance)

func handle_enemy_death(worth : int):
	emit_signal("enemy_died", worth)
	
func handle_enemy_attacking(power : float):
	emit_signal("enemy_attacking", power)
	
func clean_enemy_instance(enemy_instance):
	enemy_pool.return_enemy_instance_to_queue(enemy_instance)	

func start_checking_for_no_enemies():
	no_enemies_checker.start()

func are_all_enemies_dead() -> bool:
	if enemy_list.get_child_count() < 1:
		return true
	else:
		return false

func check_for_no_enemies():
	if are_all_enemies_dead():
		emit_signal("all_enemies_dead")
		no_enemies_checker.stop()
