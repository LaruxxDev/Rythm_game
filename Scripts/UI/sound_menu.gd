extends Control

@onready var back_button: Button = $BackButton

func _ready() -> void:
	#if Input.get_connected_joypads().size() > 0:
	#	back_button.visible = false
	pass

func _on_back_button_pressed() -> void:
	self.visible = false
