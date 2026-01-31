extends Node2D

@onready var fuego: CharacterBody2D = $Player/Fuego
@onready var agua: CharacterBody2D = $Player/Agua
@onready var tierra: CharacterBody2D = $Player/Tierra
@onready var planta: CharacterBody2D = $Player/Planta
@onready var pos_player: Marker2D = $PosPlayer
@export var distancia  =Vector2(80.0,0.0)
@onready var pos_enemy: Marker2D = $PosEnemy

const MINION = preload("uid://d4ka1nlwrsu5c")

var lista_enemies = []

func _ready() -> void:
	mover_player()
	start_round()

func mover_player():
	fuego.posicion = pos_player.global_position
	agua.posicion = fuego.posicion + distancia
	tierra.posicion = agua.posicion + distancia
	planta.posicion = tierra.posicion + distancia


func mover_enemy():
	var enemi = pos_enemy.global_position
	for i in lista_enemies:
		print(i.tipo)
		i.posicion = enemi -distancia
		enemi = i.posicion


func start_round():
	randomize()
	var num = randi_range(3,7)
	for i in num:
		spawn_enemies()
	mover_enemy()

func spawn_enemies():
	var enemi = MINION.instantiate()
	$Enemies.add_child(enemi)
	enemi.global_position += distancia
	print($Enemies.global_position)
	lista_enemies.append(enemi)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
