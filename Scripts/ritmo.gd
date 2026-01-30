extends Node2D


@export var bpm : int = 100
@export var margen : float = 0.20 # Margen de error 
var ultimo_beat = -1

var hit_beat = -1
var lista_comandos = []

var intervalo_beat = 0.0

@onready var musica = $AudioStreamPlayer
@onready var ui_beat = $CanvasLayer/ColorRect
@onready var timer: Timer = $Timer
const BIT = preload("uid://oplnfghwhb2l")

func _ready() -> void:
	ui_beat.visible = false
	intervalo_beat = 60.0 / bpm 
	timer.wait_time = intervalo_beat
	Signalbus.nuevo_beat.connect(_on_nuevo_beat)
	
	if not musica.playing:
		musica.play()

func _physics_process(_delta: float) -> void:
	
	if not musica.playing:
		return
	
	var pos_cancion = musica.get_playback_position() + AudioServer.get_time_since_last_mix() #Posicion de la cancion
	pos_cancion -= AudioServer.get_output_latency()
	
	#Beat actual (ejm: 1 )
	var beat_actual = int(pos_cancion / intervalo_beat)
	if beat_actual > ultimo_beat:
		ultimo_beat = beat_actual
		enviar_bit()
		_on_nuevo_beat()
		Signalbus.nuevo_beat.emit()
	
	var index_beat_cercano = round(pos_cancion / intervalo_beat)
	var time_beat_cercano = index_beat_cercano * intervalo_beat
	var time_margen = abs(pos_cancion - time_beat_cercano)
	
	if Input.is_action_just_pressed("fuego"):
		if intentar_beat("Chaka", time_margen, index_beat_cercano):
			Signalbus.fuego.emit()
	elif Input.is_action_just_pressed("agua"):
		if intentar_beat("Don", time_margen, index_beat_cercano):
			Signalbus.agua.emit()
	elif Input.is_action_just_pressed("tierra"):
		if intentar_beat("Pon", time_margen, index_beat_cercano):
			Signalbus.tierra.emit()
	elif Input.is_action_just_pressed("planta"):
		if intentar_beat("Pata", time_margen, index_beat_cercano):
			Signalbus.planta.emit()


func intentar_beat(tipo, time_margen, beat):
	if beat == hit_beat:
		print("NO SPAMES POLLUELO")
		return
	
	if time_margen <= margen:
		print("Perfecto!! Beat: ", beat, " - ", tipo,time_margen)
		hit_beat = beat
		registrar_input(tipo)
		return true
	else:
		print("Fallaste bribon (Diff: ", time_margen, ")")
		return false
	
	if lista_comandos.size() >= 4:
		comprobar_combo()
		

func comprobar_combo():
	var ultimos4 = lista_comandos.slice(-4)
	
	match ultimos4:
		["Pata","Pata","Pata","Pon"]:
			print("ATAQUEEERRR")
			#EMITIMOS SEÑAL
		_:
			print("te tropezaste")
			#señal
	
	resetear_combo()

func registrar_input(tipo):
	lista_comandos.append(tipo)
	
	if lista_comandos.size() >= 4:
		pass


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
