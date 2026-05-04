extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvas_layer: CanvasLayer = $CanvasLayer
var game_scene = preload("res://Scenes/mapa.tscn")

func _ready() -> void:
	cinematica()

func cinematica() -> void:
	animation_player.play("rotacionMinions")
	await get_tree().create_timer(1).timeout
	animation_player.play("llegadaEnemis")
	await animation_player.animation_finished
	animation_player.play("rotacionEnemis")
	await get_tree().create_timer(2).timeout
	animation_player.play("peleaCerca")
	await animation_player.animation_finished
	animation_player.play("peleaAtras")
	await animation_player.animation_finished
	animation_player.play("muerteEnemis")
	await animation_player.animation_finished
	animation_player.play("mascaraTiki")
	await animation_player.animation_finished
	await canvas_layer.fade(1.0, 1.5).finished
	get_tree().change_scene_to_file("res://Scenes/mapa.tscn")


	


func _on_button_pressed() -> void:
	print("aaaaa")
	get_tree().change_scene_to_file("res://Scenes/mapa.tscn")
