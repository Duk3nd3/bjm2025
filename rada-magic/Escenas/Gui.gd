extends Control

var tiempo := 0.0
var clicks :=0

func _ready():
	$Button_Volver.pressed.connect(_on_volver_pressed)
	$Button_Salir.pressed.connect(_on_salir_pressed)
	tiempo = 0.0  # Reiniciar tiempo al cargar la escena

	# Estos se van cuando unamos la mecanica con las pantallas
	$Button_Ganaste.pressed.connect(_on_ganaste_pressed)
	$Button_Perdiste.pressed.connect(_on_perdiste_pressed)

func _process(delta):
	tiempo += delta  # Sumar tiempo cada frame
	

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicks += 1

func _on_volver_pressed():
	get_tree().change_scene_to_file("res://Escenas/MenuInicial.tscn")

# Disparador de escena de VICTORIA --------------------------
func _on_ganaste_pressed():
	TimerData.tiempo_total = tiempo
	TimerData.clicks_totales = clicks
	get_tree().change_scene_to_file("res://Escenas/Ganaste.tscn")

# Disparador de escena de DERROTA --------------------------
func _on_perdiste_pressed():
	get_tree().change_scene_to_file("res://Escenas/Perdiste.tscn")
	
func _on_salir_pressed():
	get_tree().quit()
