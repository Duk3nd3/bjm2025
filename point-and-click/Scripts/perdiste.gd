extends Node2D

func _ready():
	$perder.play()

func _on_volver_pressed():
	get_tree().change_scene_to_file("res://Escenas/MenuInicial.tscn")
