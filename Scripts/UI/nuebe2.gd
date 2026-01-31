extends ParallaxLayer

const CLOUD_SPEED = -2.0

func _process(delta):
	self.motion_offset.x += CLOUD_SPEED + delta
	pass
