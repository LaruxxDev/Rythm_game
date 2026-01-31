extends Node2D

@export var tipo : String = ""
@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
var list_tipos = {
	"Fuego": "Agua", 
	"Agua": "Tierra", 
	"PLanta": "Fuego", 
	"Tierra": "Planta"}

func _ready() -> void:
	tipo_random()

func tipo_random():
	if tipo == "":
		randomize()
		var lista = list_tipos.keys()
		tipo = lista[randi_range(0,lista.size())]

func take_damage(atq_tipo):
	if tipo == list_tipos[atq_tipo]:
		muerte()


func muerte():
	queue_free()
