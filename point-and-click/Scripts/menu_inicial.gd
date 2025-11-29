extends Control
func _ready():
	$Fondo/VBoxContainer/JUGAR.pressed.connect(_on_iniciar_pressed)
	$Fondo/VBoxContainer/CREDITOS.pressed.connect(_on_creditos_pressed)
	$Fondo/VBoxContainer/SALIR.pressed.connect(_on_salir_pressed)

func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://Escenas/gameplay.tscn")

func _on_creditos_pressed():
	get_tree().change_scene_to_file("res://Escenas/Creditos.tscn")

func _on_salir_pressed():
	get_tree().quit()
