extends ParallaxLayer


#Para cuando esea para atacar (se entra en la ronda

const SUELO_SPEED = -0.50

func _process(delta):
	self.motion_offset.x += SUELO_SPEED + delta
	pass
