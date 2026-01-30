extends Control

@onready var credits: RichTextLabel = $RichTextLabel

var speed : float = 60.0

func _ready() -> void:
	await get_tree().create_timer(2).timeout

func _process(delta):
	credits.position.y -= speed * delta
