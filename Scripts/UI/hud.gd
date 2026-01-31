extends Control

@onready var vidas_container: HBoxContainer = $HBoxContainer/vidasContainer


var hearts_list: Array[TextureRect]

func _ready() -> void:
	Signalbus.lives_changed.connect(update_lives)
	for child in vidas_container.get_children():
		hearts_list.append(child)
	
	update_lives()
		
func update_lives():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = false
