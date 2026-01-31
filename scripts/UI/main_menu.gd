extends Control

@export var gameScene: PackedScene

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(gameScene)

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/setting_menu.tscn")


func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/leaderboard.tscn")
