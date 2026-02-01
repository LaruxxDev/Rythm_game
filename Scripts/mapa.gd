extends Node2D

@onready var fuego: CharacterBody2D = $Player/Fuego
@onready var agua: CharacterBody2D = $Player/Agua
@onready var tierra: CharacterBody2D = $Player/Tierra
@onready var planta: CharacterBody2D = $Player/Planta
@onready var pos_player: Marker2D = $PosPlayer
@export var distancia = Vector2(80.0,0.0)
@onready var pos_enemy: Marker2D = $PosEnemy

const MINION = preload("uid://d4ka1nlwrsu5c")
const BULLET = preload("res://Scenes/bullet.tscn")
const PLANTA = preload("uid://cw5sw2i8u2axx")
const FUEGO = preload("uid://piih1tebyb8f")
const BEAT = preload("uid://0c4vv8y2p64g")
const AGUA = preload("uid://2ewi4h56rm1l")
const TIERRA = preload("uid://4fkhik222gu0")

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
	tierra.posicion = fuego.posicion + distancia
	planta.posicion = tierra.posicion + distancia
	agua.posicion = planta.posicion + distancia


func mover_enemy():
	var enemi = pos_enemy.global_position
	for i in lista_enemies:
		i.posicion = enemi -distancia
		enemi = i.posicion


func start_round():
	ronda += 1
	randomize()
	if randi_range(0,100) >70:
		var maskRandomNum = randi_range(0,3)
		var maskListStr = ["tiki","tragicomedia","plaga","japo"]
		attack_mask(maskListStr[maskRandomNum])
		
	var num = randi_range(3,7)
	for i in num:
		spawn_enemies()
	await mover_enemy()
	beat_elemeto()
	await get_tree().create_timer(5).timeout

	
func spawn_enemies():
	var enemi: CharacterBody2D = MINION.instantiate()
	$Enemies.add_child(enemi)
	enemi.global_position += distancia
	enemi.animacion.flip_h = true
	lista_enemies.append(enemi)

func check_enemie_die(tipo: String):
	if !lista_enemies.is_empty():
		ataque(tipo)
		if lista_enemies[-1].take_damage(tipo):
			lista_enemies.pop_back()
			beat_elemeto()
			if lista_enemies.is_empty():
				Signalbus.win.emit()
				start_round()

func beat_elemeto():
	if lista_enemies.is_empty():
		$Ritmo.textura = BEAT
		return
	match lista_enemies[-1].tipo:
		"Fuego":
			$Ritmo.textura = AGUA
		"Planta":
			$Ritmo.textura = FUEGO
		"Tierra":
			$Ritmo.textura = PLANTA
		"Agua":
			$Ritmo.textura = TIERRA
		

func ataque(tipo: String):
	match tipo:
		"Agua":
			hidrochorro()
		"Fuego":
			bolafuego(tipo)
		"Planta":
			bolaplanta(tipo)
		"Tierra":
			bolatierra(tipo)
	pass
func hidrochorro():
	$Player/Agua/AnimatedSprite2D2.visible = true
	await get_tree().create_timer(1).timeout
	$Player/Agua/AnimatedSprite2D2.visible = false

func bolafuego(tipo):
	var bala = BULLET.instantiate()
	fuego.add_child(bala)
	bala.play(tipo)
	teledigiro(bala)


func bolaplanta(tipo):
	var bala = BULLET.instantiate()
	planta.add_child(bala)
	bala.play(tipo)
	teledigiro(bala)

func bolatierra(tipo):
	var bala = BULLET.instantiate()
	tierra.add_child(bala)
	bala.play(tipo)
	teledigiro(bala)

func teledigiro(bala:AnimatedSprite2D):
	if lista_enemies.is_empty():
		bala.queue_free()
		return
	bala.rotation = -25.0
	var tween = create_tween().tween_property(bala, "global_position",lista_enemies[-1].global_position - Vector2(0.0,300),2.0)
	await tween.finished
	if lista_enemies.is_empty():
		bala.queue_free()
		return
	bala.rotation = 90

	var tween2 = create_tween().tween_property(bala, "global_position",lista_enemies[-1].global_position,1.0)
	await tween2.finished
	bala.queue_free()

func _on_agua():
	check_enemie_die("Agua")

func _on_fuego():
	check_enemie_die("Fuego")

	
func _on_tierra():
	check_enemie_die("Tierra")


func _on_planta():
	check_enemie_die("Planta")

func attack_mask(mask: String):
	Signalbus.emit_signal(str(mask+"_mask"))
	var maskNode = $MaskHUD.get_node(mask)
	maskNode.visible = true
	var maskAnim = maskNode.get_node(mask+"anim")
	maskAnim.visible = true
	await get_tree().create_timer(30).timeout
	maskAnim.visible = false
	maskNode.visible = false
	Signalbus.mask_off.emit()
