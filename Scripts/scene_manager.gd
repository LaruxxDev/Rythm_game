extends Node

signal game_paused(paused: bool)

func pause_game(paused: bool):
	get_tree().paused = paused
	game_paused.emit(paused)
