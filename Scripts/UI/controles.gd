extends Control

@onready var arriba: AnimatedSprite2D = $Label/Arriba
@onready var derecha: AnimatedSprite2D = $Label2/Derecha
@onready var izquierda: AnimatedSprite2D = $Label4/Izquierda
@onready var abajo: AnimatedSprite2D = $Label3/Abajo

@export var textura : String
@export var texto ={
	"esquives":["Saltar","Esquivar","Agacharse","Esconderse"],
	"flechas":["Fuego","Planta","Tierra","Agua"],
	"mando_atq":["Fuego","Planta","Tierra","Agua"],
	"mando_esq":["Saltar","Esquivar","Agacharse","Esconderse"]


}


func _ready() -> void:
	if textura:
		arriba.play(textura)
		derecha.play(textura)
		izquierda.play(textura)
		abajo.play(textura)
		
		$Label.text = texto[textura][0] 
		$Label2.text = texto[textura][1] 
		$Label3.text = texto[textura][2] 
		$Label4.text = texto[textura][3] 
