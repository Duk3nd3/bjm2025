extends Node2D

func _ready():
	var t = TimerData.tiempo_total
	var s = TimerData.score
	var v = TimerData.lives
	$Label.text = "Ganaste!\nTiempo: %.2f s\nPuntaje: %.2f\nVidas Restantes: %.2f" % [t,s,v]
	$Button_Volver.pressed.connect(_on_volver_pressed)

func _on_volver_pressed():
	get_tree().change_scene_to_file("res://Escenas/MenuInicial.tscn")
