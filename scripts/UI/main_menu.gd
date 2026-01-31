extends Control

@export var gameScene: PackedScene

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(gameScene)

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.
