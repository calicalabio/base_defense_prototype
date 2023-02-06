extends CanvasLayer

signal start_round()

onready var round_number_label = $RoundNumberLabel
onready var round_timer_label = $RoundTimerLabel
onready var start_round_button = $ButtonStartRound
onready var currency_label = $CurrencyLabel
onready var kill_count_label = $KillCountLabel
onready var player_hp_label = $PlayerHealthLabel

func setup_active_round_hud():
	round_timer_label.visible = true
	start_round_button.visible = false
	
func setup_inactive_round_hud():
	round_timer_label.visible = false
	start_round_button.visible = true

func update_round_number(number : int):
	round_number_label.text = "Round " + str(number)

func update_round_time(time_left : float):
	round_timer_label.text = "Time Left: " + str(int(time_left + 1.0))

func set_round_time_label(text : String):
	round_timer_label.text = text

func update_currency(amount : int):
	currency_label.text = "Currency: " + str(amount)
	
func update_kill_count(kills : int):
	kill_count_label.text = "Kills: " + str(kills)

func update_player_hp(hp : float):
	player_hp_label.text = "Base HP: " + str(int(hp))

func _on_ButtonStartRound_pressed() -> void:
	emit_signal("start_round")
