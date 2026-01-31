extends Node

var lives = 5
	
func lose_life(amount: float):
	lives -= amount
	if lives < 0:
		lives = 0
		
	Signalbus.lives_changed.emit()
	
