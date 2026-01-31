extends Node2D

const BIT = preload("uid://oplnfghwhb2l")

@export var bpm : int = 120
@export var margen : float = 0.20 # Margen de error 
var ultimo_beat = -1

var historial = -1
var hit_beat = -1
var lista_comandos = []

var intervalo_beat = 0.0

@onready var musica = $Base
@onready var ui_beat = $ColorRect
@onready var timer: Timer = $Timer


func _ready() -> void:
	ui_beat.visible = false
	intervalo_beat = 60.0 / bpm 
	timer.wait_time = intervalo_beat
	Signalbus.nuevo_beat.connect(_on_nuevo_beat)
	Signalbus.win.connect(_on_win_round)
	if not musica.playing:
		musica.play()

func _physics_process(_delta: float) -> void:
	if not musica.playing:
		musica.play()
		print(3333)

	var pos_cancion = musica.get_playback_position() + AudioServer.get_time_since_last_mix() #Posicion de la cancion
	pos_cancion -= AudioServer.get_output_latency()
	#Beat actual (ejm: 1 )
	var beat_actual = int(pos_cancion / intervalo_beat)
	print(beat_actual)
	if ultimo_beat > beat_actual:
		ultimo_beat = -1
	if beat_actual > ultimo_beat:
		ultimo_beat = beat_actual
		enviar_bit()
		_on_nuevo_beat()
		Signalbus.nuevo_beat.emit()

	var index_beat_cercano = round(pos_cancion / intervalo_beat)
	var time_beat_cercano = index_beat_cercano * intervalo_beat
	var time_margen = abs(pos_cancion - time_beat_cercano)
	
	if Input.is_action_just_pressed("fuego"):
		if intentar_beat(time_margen, index_beat_cercano):
			Signalbus.fuego.emit()
	elif Input.is_action_just_pressed("agua"):
		if intentar_beat(time_margen, index_beat_cercano):
			Signalbus.agua.emit()
	elif Input.is_action_just_pressed("tierra"):
		if intentar_beat(time_margen, index_beat_cercano):
			Signalbus.tierra.emit()
	elif Input.is_action_just_pressed("planta"):
		if intentar_beat(time_margen, index_beat_cercano):
			Signalbus.planta.emit()


func intentar_beat(time_margen, beat):
	if beat == hit_beat or beat == historial+1:
		Signalbus.fallo.emit()
		print("NO SPAMES POLLUELO")
		return
	if not lista_comandos.is_empty() and lista_comandos[lista_comandos.size()-1] != beat-1:
		Signalbus.fallo.emit()
		resetear_combo()
		print("te as saltado 1")
		return
	
	if time_margen <= margen:
		print("Perfecto!! Beat: ", beat, " - ",time_margen)
		hit_beat = beat
		lista_comandos.append(beat)
		return true
	else:
		print("Fallaste bribon (Diff: ", time_margen, ")")
		return false
	


func resetear_combo():
	lista_comandos.clear()

func _on_nuevo_beat():
	ui_beat.visible = true

	var tween = create_tween()
	
	tween.tween_interval(margen)
	
	tween.tween_callback(func(): ui_beat.visible = false)

func _on_timer_timeout() -> void:
	timer.wait_time = intervalo_beat
	timer.start()
	

func _on_win_round():
	lista_comandos.clear()


func enviar_bit():
	var bit = BIT.instantiate()
	var bit2 = BIT.instantiate()
	$Spawner2.add_child(bit2)
	$Spawner.add_child(bit)
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(bit, "global_position", $Sprite2D.global_position, intervalo_beat)
	tween.tween_property(bit2, "global_position", $Sprite2D.global_position, intervalo_beat)
	await tween.finished
	bit.queue_free()
	bit2.queue_free()
