extends Node2D

@onready var fuego: CharacterBody2D = $Player/Fuego
@onready var agua: CharacterBody2D = $Player/Agua
@onready var tierra: CharacterBody2D = $Player/Tierra
@onready var planta: CharacterBody2D = $Player/Planta
@onready var pos_player: Marker2D = $PosPlayer
@export var distancia = Vector2(80.0,0.0)
@onready var pos_enemy: Marker2D = $PosEnemy

const MINION = preload("uid://d4ka1nlwrsu5c")

var lista_enemies = []
var ronda = 0

func _ready() -> void:
	Signalbus.agua.connect(_on_agua)
	Signalbus.fuego.connect(_on_fuego)
	Signalbus.tierra.connect(_on_tierra)
	Signalbus.planta.connect(_on_planta)

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
	ronda += 1
	randomize()
	var num = randi_range(3,7)
	for i in num:
		spawn_enemies()
	await mover_enemy()
	await get_tree().create_timer(5).timeout

	
func spawn_enemies():
	var enemi = MINION.instantiate()
	$Enemies.add_child(enemi)
	enemi.global_position += distancia
	print($Enemies.global_position)
	lista_enemies.append(enemi)

func _on_agua():
	lista_enemies[-1].take_damage("Agua")
	
func _on_fuego():
	lista_enemies[-1].take_damage("Fuego")

	
func _on_tierra():
	lista_enemies[-1].take_damage("Tierra")

	
func _on_planta():
	lista_enemies[-1].take_damage("Planta")

	
	
	
	
	
	
	
	
	
	
	
	
