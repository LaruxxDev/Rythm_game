extends Control

@onready var vidas_container: HBoxContainer = $HBoxContainer/vidasContainer
@onready var rondas: Label = $HBoxContainer/Rondas


var hearts_list: Array[TextureRect]

func _ready() -> void:
	Signalbus.fallo.connect(update_lives)

	for child in vidas_container.get_children():
		hearts_list.append(child)
		
func update_lives():
	if hearts_list.size() != 0 :
		
		hearts_list[-1].queue_free()
		hearts_list.pop_back()
	else:
		get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")
		
func next_ronda(ronda:int):
	rondas.text = "Ronda: " + str(ronda) 
