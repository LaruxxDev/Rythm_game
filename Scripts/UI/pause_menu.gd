extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	SceneManager.game_paused.connect(set_paused)
	
func set_paused(paused: bool) -> void:
	visible = paused
	
func _unhandled_input(event):
	if event.is_action_pressed("pausar"):
		SceneManager.pause_game(true)


func _on_resume_pressed() -> void:
	SceneManager.pause_game(false)


func _on_settings_pressed() -> void:
	$SettingMenu.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()
