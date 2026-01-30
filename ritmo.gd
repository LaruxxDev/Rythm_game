extends Node2D


@export var bpm : int = 120
@export var margen : float = 0.30 # Margen de error 
var ultimo_beat = -1

var lista_comandos = []

var intervalo_beat = 0.0

@onready var musica = $AudioStreamPlayer
@onready var ui_beat = $CanvasLayer/ColorRect
func _ready() -> void:
	ui_beat.visible = false
	intervalo_beat = 60.0 / bpm
	Signalbus.connect("nuevo_beat",_on_nuevo_beat)
	
	if not musica.playing:
		musica.play()

func _physics_process(delta: float) -> void:
	
	if not musica.playing:
		return
	
	var pos_cancion = musica.get_playback_position() + AudioServer.get_time_since_last_mix() #Posicion de la cancion
	pos_cancion -= AudioServer.get_output_latency()
	
	#Beat actual (ejm: 1 )
	var beat_actual = int(pos_cancion / intervalo_beat)
	if beat_actual > ultimo_beat:
		ultimo_beat = beat_actual
		emit_signal("nuevo_beat")
	
	var index_beat_cercano = round(pos_cancion / intervalo_beat)
	var time_beat_cercano = index_beat_cercano * intervalo_beat
	var time_margen = abs(pos_cancion - time_beat_cercano)
	
	if Input.is_action_just_pressed("ui_up"):
		intentar_beat("Chaka", time_margen, index_beat_cercano)
	elif Input.is_action_just_pressed("ui_down"):
		intentar_beat("Don", time_margen, index_beat_cercano)
	elif Input.is_action_just_pressed("ui_left"):
		intentar_beat("Pon", time_margen, index_beat_cercano)
	elif Input.is_action_just_pressed("ui_right"):
		intentar_beat("Pata", time_margen, index_beat_cercano)
	pass

func intentar_beat(tipo, time_margen, beat):
	if beat == ultimo_beat:
		print("NO SPAMES POLLUELO")
		return
	
	if time_margen <= margen:
		print("Perfecto!! Beat: ", beat, " - ", tipo)
		ultimo_beat = beat
		registrar_input(tipo)
	else:
		print("Fallaste bribon (Diff: ", time_margen, ")")
		
		

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
	print("Combo no encontrado ¡¡TROPEZASTE!!")
	lista_comandos.clear()

func _on_nuevo_beat():
	ui_beat.visible = true
	var tween = create_tween()
	tween.tween_interval(margen)
	
	tween.tween_callback(func(): ui_beat.visible = false)
