extends ParallaxLayer

const CLOUD_SPEED = -1.0

func _process(delta):
	self.motion_offset.x += CLOUD_SPEED + delta
	pass
