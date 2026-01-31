extends Control

@onready var vidas_container: HBoxContainer = $HBoxContainer/vidasContainer
@onready var rondas: Label = $HBoxContainer/Rondas


var hearts_list: Array[TextureRect]

func _ready() -> void:
	Signalbus.fallo.connect(update_lives)

	for child in vidas_container.get_children():
		hearts_list.append(child)
		
func update_lives():
	await get_tree().create_timer(2).timeout
	hearts_list[-1].queue_free()
	hearts_list.pop_back()
		
func next_ronda(ronda:int):
	rondas.text = "Ronda: " + str(ronda) 
