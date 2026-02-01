extends Node

signal game_paused(paused: bool)
var score = 0

func _ready() -> void:
	Signalbus.kill.connect(mas_score)

func mas_score(amount):
	score+= amount

func pause_game(paused: bool):
	get_tree().paused = paused
	game_paused.emit(paused)
