extends CharacterBody2D

@export var tipo : String = ""
@export var speed = 300

@export var posicion : Vector2
@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
var list_tipos = {
	"Fuego": "Agua", 
	"Agua": "Tierra", 
	"Planta": "Fuego", 
	"Tierra": "Planta"}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	tipo_random()
	moverse()
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if position.distance_to(posicion) < 5:
		velocity.x = 0
	else:
		moverse()
	move_and_slide()
	
func handel_animacion():
	if velocity.x != 0:
		animacion.play(str(tipo,"_idle"))
	else:
		animacion.play(str(tipo,"_idle"))
	if velocity.x > 0:
		animacion.flip_h = false
	if velocity.x < 0:
		animacion.flip_h = true

func moverse():
	var direction = (posicion - global_position).normalized()
	velocity.x = direction.x * speed

func tipo_random():
	if tipo == "":
		randomize()
		var lista = list_tipos.keys()
		tipo = lista[randi_range(0,lista.size()-1)]
	elegir_animacion()

func elegir_animacion():
	animacion.play(str(tipo,"_idle"))

func take_damage(atq_tipo):
	if atq_tipo == list_tipos[tipo]:
		muerte()
		return true
	else:
		Signalbus.fallo.emit()
		return false



func muerte():
	#animacion.play(str(tipo,"_dead"))
	
	queue_free()
