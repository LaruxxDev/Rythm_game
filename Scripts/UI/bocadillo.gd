extends TextureRect

@export var pj :String
var dialogos = {
	"Minion": 
	["Conquita el mundo","perrooooos"],
	

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
		$RichTextLabel2.text = list[0]
		visible = true
		set_process(true)

func terminar_dialogo():
	visible = false
	set_process(false) 
	Signalbus.finish_dialoge.emit()
	queue_free()
