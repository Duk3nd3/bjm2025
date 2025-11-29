extends Node2D

func _ready():
	var t = TimerData.tiempo_total
	var c = TimerData.clicks_totales
	$Label.text = "¡Ganaste!\nTiempo: %.2f s\nClics: %d" % [t, c]
	$Button_Volver.pressed.connect(_on_volver_pressed)

func _on_volver_pressed():
	get_tree().change_scene_to_file("res://Escenas/MenuInicial.tscn")
