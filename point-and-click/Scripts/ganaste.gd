extends Node2D

@onready var labels = [$TiempoLabel,$PuntajeLabel,$VidasLabel]


func _ready():
	var t = TimerData.tiempo_total
	var s = TimerData.score
	var v = TimerData.lives
	
	$TiempoLabel.text= "Tiempo Total: %d" % t
	$PuntajeLabel.text = "Puntaje Final: %d" % s
	$VidasLabel.text = "Vidas restantes: %d" % v
	
	fade_labels_sequentials(labels,1.0)	
	#$Label.text = "Ganaste!\nTiempo: %.2f s\nPuntaje: %.2f\nVidas Restantes: %.2f" % [t,s,v]
	$Button_Volver.pressed.connect(_on_volver_pressed)

func fade_labels_sequentials(label_list,fade_time: float):
	for l in label_list:
		l.modulate.a = 0.0
		start_fade_sequence(label_list,fade_time)

func start_fade_sequence(label_list,fade_time) ->void:
	for lbl in label_list:
		var tween = get_tree().create_tween()
		tween.tween_property(lbl,"modulate:a",1.0, fade_time)
		await tween.finished

func _on_volver_pressed():
	get_tree().change_scene_to_file("res://Escenas/MenuInicial.tscn")
