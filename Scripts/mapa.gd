extends Node2D

@onready var fuego: CharacterBody2D = $Player/Fuego
@onready var agua: CharacterBody2D = $Player/Agua
@onready var tierra: CharacterBody2D = $Player/Tierra
@onready var planta: CharacterBody2D = $Player/Planta
@onready var pos_player: Marker2D = $PosPlayer
@export var distancia  =Vector2(80.0,0.0)

func _ready() -> void:
	mover_player()

func mover_player():
	fuego.posicion = pos_player.global_position
	agua.posicion = fuego.posicion + distancia
	tierra.posicion = agua.posicion + distancia
	planta.posicion = tierra.posicion + distancia
