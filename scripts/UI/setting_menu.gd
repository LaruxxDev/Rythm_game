extends Control

@export var mainScene: PackedScene

@onready var sound_menu: Control = $SoundMenu
@onready var controles_menu: Control = $ControlesMenu

func _on_controls_button_pressed() -> void:
	controles_menu.visible = true

func _on_sound_button_pressed() -> void:
	sound_menu.visible = true

func _on_resume_button_pressed() -> void:
	visible = false 


func _on_exit_button_pressed() -> void:
	visible = false
