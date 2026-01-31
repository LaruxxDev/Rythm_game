extends Panel

@export var pj :String
var dialogos = {
	"Minion": 
	["Conquita el mundo"],
	

}

var cont = 0
var list = []

func _ready() -> void:

	Signalbus.finish_dialoge.connect(mostrar_dialogo)

	if dialogos.has(pj):
		list = dialogos[pj]
		$VBoxContainer/Label.text = "[color=yellow]"+ pj
	else:
		print("Error: No hay diálogo para ", pj)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interactuar") and visible:
		cont += 1
		
		if cont < list.size():
			$VBoxContainer/Label2.text = list[cont]
		else:
			terminar_dialogo()

func mostrar_dialogo():
	
	if list.size() > 0 :
		$VBoxContainer/Label2.text = list[0]
		visible = true
		set_process(true)

func terminar_dialogo():
	visible = false
	set_process(false) 
	if pj == "Abeja soldado":
		pass
	else:
		Signalbus.finish_dialoge.emit()
	queue_free()
