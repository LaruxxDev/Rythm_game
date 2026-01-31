extends Control


@onready var option_button: CheckButton = $HBoxContainer/Container2/OptionButton


func _on_back_button_pressed() -> void:
	visible = false



func _on_option_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
