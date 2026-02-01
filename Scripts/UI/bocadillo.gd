extends TextureRect

@export var pj :String
var dialogos = {
	"intro": 
		["Somos un pueblo que adora a las máscaras.\nRecibimos nuestro poder de ellas.",
		"Hace poco hemos recibido una señal de nuestros dioses enmascarados.\nQuieren acabar con nosotros.\nPero no se lo pondremos fácil.",
		"El problema es que somos algo torpes.\n¡Por eso te necesitamos!\nGuíanos tocando el tambor divino para defendernos de nuestros vecinos hostiles."
		],
	"minion":
		["No pasareis", 
		" Aunque los dioses quieran erradicarlos\n Nosotros prevaleceremos"
		],
	"enemi":
		["Ni lo soñeis\n Nosotros somos quienes quedaremos en pie",
		 "Preparaos para sufrir el destino que se os ha impuesto"
		],
	"mask":
		["Puede que hayáis acabado con mis fieles… Pero no permitiré vuestra herejía", 
		"¡CAED!"
		]
}

var cont = 0
var list = []

func _ready() -> void:

	Signalbus.finish_dialoge.connect(mostrar_dialogo)

	if dialogos.has(pj):
		list = dialogos[pj]
	else:
		print("Error: No hay diálogo para ", pj)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and visible:
		cont += 1
		
		if cont < list.size():
			$RichTextLabel2.text = list[cont]
		else:
			terminar_dialogo()

func mostrar_dialogo():
	
	if list.size() > 0 :
		cont = 0
		$RichTextLabel2.text = list[0]
		visible = true
		set_process(true)

func terminar_dialogo():
	visible = false
	set_process(false) 
	Signalbus.finish_dialoge.emit()
	queue_free()
