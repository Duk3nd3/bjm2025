extends Control

@onready var labels = [$Historia1,$Historia2,$Historia3]



func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://Escenas/gameplay.tscn")

func _on_creditos_pressed():
	get_tree().change_scene_to_file("res://Escenas/Creditos.tscn")

func _on_salir_pressed():
	get_tree().quit()



func _ready():
	$FondoPlaceholder/VBoxContainer/JUGAR.pressed.connect(_on_iniciar_pressed)
	$FondoPlaceholder/VBoxContainer/CREDITOS.pressed.connect(_on_creditos_pressed)
	$FondoPlaceholder/VBoxContainer/SALIR.pressed.connect(_on_salir_pressed)


#---------------------------------------------------------------------------------------
	var t ="En las sombras del viejo teatro, el Gran Mago ha perdido sus objetos más preciados.
Sin su sombrero encantado, su varita ancestral y las reliquias de su poder,
la función no puede comenzar."

	var s ="Explora cada rincón, descubre los secretos ocultos entre la escenografía
y recupera todo lo que el teatro ha escondido."

	var v ="Solo cuando tenga cada uno de sus artefactos, la magia podrá volver a brillar en el escenario.¿Estás listo para ayudarlo?"


	$Historia1.text=  t
	$Historia2.text =  s
	$Historia3.text =  v
	
	fade_labels_sequentials(labels,2)	

func fade_labels_sequentials(label_list,fade_time: float):
	for l in label_list:
		l.modulate.a = 0.0
		start_fade_sequence(label_list,fade_time)

func start_fade_sequence(label_list,fade_time) ->void:
	for lbl in label_list:
		var tween = get_tree().create_tween()
		tween.tween_property(lbl,"modulate:a",1.0, fade_time)
		await tween.finished


#------------------------------------------------------------------------
