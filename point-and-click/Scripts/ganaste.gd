extends Control

# Referencia al contenedor principal para poder acceder a sus hijos
@onready var contenedor_principal: VBoxContainer = $ContenedorPrincipal

func _ready():
	# Obtenemos los datos que guardamos al ganar
	var t = TimerData.tiempo_total
	var s = TimerData.score
	var v = TimerData.lives
	
	# Buscamos los labels dentro del contenedor y les ponemos el texto
	$ContenedorPrincipal/TituloLabel.text = "¡FELICIDADES, GANASTE!"
	$ContenedorPrincipal/TiempoLabel.text = "Tiempo Total: %d segundos" % t
	$ContenedorPrincipal/PuntajeLabel.text = "Puntaje Final: %d" % s
	$ContenedorPrincipal/VidasLabel.text = "Vidas restantes: %d" % v
	
	# Conectamos la señal del boton para que vuelva al menu
	$ContenedorPrincipal/Button_Volver.pressed.connect(_on_volver_pressed)
	
	# Iniciamos la animacion de desvanecimiento
	fade_in_all_labels()

# Funcion que hace el efecto de desvanecimiento en todos los labels
func fade_in_all_labels():
	# Primero los dejamos invisibles
	for label in contenedor_principal.get_children():
		if label is Label:
			label.modulate.a = 0.0
	
	# Esperamos un poquito antes de empezar la animacion
	await get_tree().create_timer(0.5).timeout
	
	# Creamos una animacion (Tween)
	var tween = create_tween()
	
	# Animamos todos los labels a la vez para que aparezcan juntos
	for label in contenedor_principal.get_children():
		if label is Label:
			# Usamos tween.set_parallel() para que todas las animaciones pasen a la vez
			tween.set_parallel().tween_property(label, "modulate:a", 1.0, 1.0)

# Funcion que se ejecuta al apretar el boton de volver
func _on_volver_pressed():
	print("Volviendo al menu principal...")
	get_tree().change_scene_to_file("res://Escenas/MenuInicial.tscn")
