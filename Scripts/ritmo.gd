extends Node2D

const BIT = preload("uid://oplnfghwhb2l")

var bpm : int = 120
@export var margen : float = 0.35 # Margen de error 
var ultimo_beat = -1

var historial = -1
var hit_beat = -1
var lista_comandos = []
var lista_enemigos= []
var intervalo_beat = 0.0

var textura : Texture

@onready var musica: AudioStreamPlayer = $Base
@onready var claqueta: AudioStreamPlayer = $Claqueta
@onready var tiki: AudioStreamPlayer = $Tiki
@onready var japo: AudioStreamPlayer = $Japo
@onready var tragicomedia: AudioStreamPlayer = $Tragicomedia
@onready var plaga: AudioStreamPlayer = $Plaga

@onready var ui_beat = $Sprite2D
@onready var timer: Timer = $Timer
var score = 0
var tiki_on = false
var japo_on = false
var tragi_on = false
var plaga_on = false

func _ready() -> void:
	ui_beat.visible = false
	bpm = 120 * claqueta.pitch_scale

	intervalo_beat = 60.0 / bpm 
	timer.wait_time = intervalo_beat
	Signalbus.increchendo.connect(subir_bpm)
	Signalbus.nuevo_beat.connect(_on_nuevo_beat)
	Signalbus.win.connect(_on_win_round)
	Signalbus.tiki_mask.connect(_on_tiki_mask)
	Signalbus.japo_mask.connect(_on_japo_mask)
	Signalbus.tragicomedia_mask.connect(_on_tragicomedia_mask)
	Signalbus.plaga_mask.connect(_on_plaga_mask)
	Signalbus.mask_off.connect(_on_mask_off)
	_on_mask_off()
	igualar_bpm()
	if not musica.playing:
		musica.play()

func _physics_process(_delta: float) -> void:
	if not musica.playing:
		musica.play()
	bpm = 120 * claqueta.pitch_scale
	intervalo_beat = 60.0 / bpm 
	var pos_cancion = musica.get_playback_position() + AudioServer.get_time_since_last_mix() #Posicion de la cancion
	pos_cancion -= AudioServer.get_output_latency()
	#Beat actual (ejm: 1 )
	var beat_actual = int(pos_cancion / intervalo_beat)
	if ultimo_beat > beat_actual:
		ultimo_beat = -1
	if beat_actual > ultimo_beat:
		ultimo_beat = beat_actual
		#enviar_bit()
		_on_nuevo_beat()
		#Signalbus.nuevo_beat.emit()

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

func _input(event: InputEvent) -> void:
	if tiki_on:
		if event.is_action_pressed("saltar"):
			score += 1
			$score.text = "[wave] [rainbow]%d" % score

	if japo_on:
		if event.is_action_pressed("esquivar"):
			score += 1
			$score.text = "[wave] [rainbow]%d" % score

	if tragi_on:
		if event.is_action_pressed("agacharse"):
			score += 1
			$score.text = "[wave] [rainbow]%d" % score

	if plaga_on:
		if event.is_action_pressed("esconderse"):
			score += 1
			$score.text = "[wave] [rainbow]%d" % score



func subir_bpm(num):
	if musica.pitch_scale >= 1.1:
		return
	musica.pitch_scale += num
	igualar_bpm()

func igualar_bpm():
	claqueta.pitch_scale = musica.pitch_scale
	tiki.pitch_scale = musica.pitch_scale
	japo.pitch_scale = musica.pitch_scale
	tragicomedia.pitch_scale = musica.pitch_scale
	plaga.pitch_scale = musica.pitch_scale

func intentar_beat(time_margen, beat):
	if beat == hit_beat or beat == historial+1:
		Signalbus.fallo.emit()
		$damage.play()
		print("NO SPAMES POLLUELO")
		return false
	if not lista_comandos.is_empty() and lista_comandos[lista_comandos.size()-1] != beat-1:
		$damage.play()

		resetear_combo()
		print("te as saltado 1")
		return true
	
	if time_margen <= margen:
		print("Perfecto!! Beat: ", beat, " - ",time_margen)
		$win.play()
		hit_beat = beat
		lista_comandos.append(beat)
		return true
	else:
		
		print("Fallaste bribon (Diff: ", time_margen, ")")
		return false
	


func resetear_combo():
	lista_comandos.clear()

func _on_nuevo_beat():
	if textura :
		ui_beat.texture = textura
	
	ui_beat.visible = !ui_beat.visible
	
	var tween = create_tween()
	
	tween.tween_interval(margen)
	
	tween.tween_callback(func(): ui_beat.visible = !ui_beat.visible)

func _on_timer_timeout() -> void:
	timer.wait_time = intervalo_beat
	timer.start()
	
func _on_win_round():
	lista_comandos.clear()
	historial = -1
	
func _on_tiki_mask():
	play_masks("Tiki")
	tiki_on = true
	if mando_on():
		$AnimatedSprite2D.play("tiki_2")
	else:
		$AnimatedSprite2D.play("tiki")
func mando_on():
	$score.visible = true
	$score.text = "[wave] %d" % score
	if Input.get_connected_joypads().size() > 0:
		return true
	else:
		return false
	
func _on_japo_mask():
	play_masks("Japo")
	japo_on = true
	if mando_on():
		$AnimatedSprite2D.play("oni_2")
	else:
		$AnimatedSprite2D.play("oni")

func _on_tragicomedia_mask():
	play_masks("Tragi")
	tragi_on = true
	if mando_on():
		$AnimatedSprite2D.play("trag_2")
	else:
		$AnimatedSprite2D.play("trag")
func _on_plaga_mask():
	play_masks("Plaga")
	plaga_on = true
	if mando_on():
		$AnimatedSprite2D.play("peste_2")
	else:
		$AnimatedSprite2D.play("peste")
func detallito():
	$score.visible = true
	await get_tree().create_timer(3).timeout
	$score.visible = false

func _on_mask_off():
	$AnimatedSprite2D.visible = false
	if $score.visible:
		detallito()
	tiki_on = false
	japo_on = false
	tragi_on = false
	plaga_on = false
	Signalbus.kill.emit(score)
	score = 0
	mute_masks("Tiki")
	mute_masks("Japo")
	mute_masks("Tragi")
	mute_masks("Plaga")

func play_masks(tipo:String):
	$AnimatedSprite2D.visible = true
	var index = AudioServer.get_bus_index(tipo)
	var tween: Tween = create_tween()
	tween.tween_method(func(val):AudioServer.set_bus_volume_db(index,val),-80.0, 0,1 )

func mute_masks(tipo:String):
	var index = AudioServer.get_bus_index(tipo)
	var tween: Tween = create_tween()
	tween.tween_method(func(val):AudioServer.set_bus_volume_db(index,val),0, -80,1 )
	await tween.finished

#func enviar_bit():
	#var bit = BIT.instantiate()
	#var bit2 = BIT.instantiate()
	#$Spawner2.add_child(bit2)
	#$Spawner.add_child(bit)
	#var tween: Tween = get_tree().create_tween().set_parallel(true)
	#tween.tween_property(bit, "global_position", $Sprite2D.global_position, intervalo_beat + margen)
	#tween.tween_property(bit2, "global_position", $Sprite2D.global_position, intervalo_beat+ margen)
	#await tween.finished
	#bit.queue_free()
	#bit2.queue_free()
