extends Area2D

signal enemy_clicked(enemy_instance)
signal enemy_died(worth)
signal enemy_attacking(power)
signal clean_up(instance)

onready var sprite = $AnimatedSprite
onready var attack_timer = $AttackTimer

export var speed : float = 1
export var max_hp : float = 10.0
export var worth : int = 10
export var power : float = 1.0

var current_hp : float = 10.0
var is_sieging : bool = false

func initialise_enemy():
	current_hp = max_hp
	is_sieging = false
#	print(self.global_position)

func _physics_process(_delta):
	if not is_sieging:
		global_position.x -= speed

func handle_clicked():
	emit_signal("enemy_clicked", self)

func take_damage(damage : float):
	current_hp -= damage
	
	if current_hp <= 0.0:
		die()

func begin_siege():
	is_sieging = true

func try_attack():
	if is_sieging:
		emit_signal("enemy_attacking", power)

func die():
	emit_signal("enemy_died", worth)
	emit_signal("clean_up", self)

	
