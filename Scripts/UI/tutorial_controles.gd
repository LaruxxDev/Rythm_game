extends Control


func _ready() -> void:
	if Input.get_connected_joypads().size() > 0:
		$mando.visible = false
		$teclado.visible = true
	else:
		$mando.visible = true
		$teclado.visible = false


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/tutorial.tscn")
