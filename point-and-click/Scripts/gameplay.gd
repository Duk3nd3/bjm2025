extends Node2D
#REFERENCIAS A LOS ICONITOS DEL JUEGO

@onready var galeraColor: Sprite2D = $galeraColor
@onready var galeraGris: Sprite2D = $galeraGris
@onready var varitaColor: Sprite2D = $varitaColor
@onready var varitaGris: Sprite2D = $varitaGris
@onready var capaColor: Sprite2D = $capaColor
@onready var capaGris: Sprite2D = $capaGris

#REFERENCIAS A LOS ICONITOS DE VIDA
@onready var lives_container: HBoxContainer = $LivesContainer
var life_icons: Array[Sprite2D] = []

# Referencia al poster
@onready var poster_radagast: Sprite2D = $PosterRadagast

#VARIABLES DE ESTADO DEL JUEGO
var swap_pairs = []
var lives = 5
var time = 0
var score = 0 #Puntaje inicial

func _ready():
	print("Juego iniciado. Tenes 5 vidas.")
	
	#Agregamos una comprobacion de seguridad
	if poster_radagast:
		#Preparamos el poster para que aparezca con un efecto de desvanecimiento
		poster_radagast.modulate.a = 0.0 #Lo hacemos completamente transparente
		poster_radagast.visible = true #Lo hacemos visible pero invisible (necesario para el tween)
	else:
		print("OJO!: El nodo PosterRadagast no fue encontrado en la escena.")
	
	life_icons.clear()
	for child in lives_container.get_children():
		if child is Sprite2D:
			life_icons.append(child)
		else:
			print("OJO!: Se encontro un nodo que no es Sprite2D en LivesContainer: ", child.name)
	
	swap_pairs = [
		{"main_sprite": galeraColor, "gray_sprite": galeraGris, "can_swap": true},
		{"main_sprite": varitaColor, "gray_sprite": varitaGris, "can_swap": true},
		{"main_sprite": capaColor, "gray_sprite": capaGris, "can_swap": true}
	]
	
	update_lives_display()

func _process(delta):
	time += delta

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		var mouse_pos = get_global_mouse_position()
		var hit_detected = false
		
		for pair in swap_pairs:
			var main_rect = pair.main_sprite.get_rect()
			main_rect.position += pair.main_sprite.global_position
			
			if main_rect.has_point(mouse_pos):
				hit_detected = true
				
				if pair.can_swap:
					print("ACERTASTE en el icono ", pair.main_sprite.name, "!")
					score += 100
					print("Puntuacion: ", score)
					
					var temp_pos = pair.main_sprite.position
					var temp_rot = pair.main_sprite.rotation
					pair.main_sprite.position = pair.gray_sprite.position
					pair.main_sprite.rotation = pair.gray_sprite.rotation
					pair.gray_sprite.position = temp_pos
					pair.gray_sprite.rotation = temp_rot
					
					pair.can_swap = false
					check_victory_condition()
					
				else:
					print("Este icono (", pair.main_sprite.name, ") ya fue intercambiado.")
				
				break

		if not hit_detected:
			print("ERRASTE! Perdes una vida.")
			lose_a_life()

#LOGICA DE VICTORIA CON AWAIT
func check_victory_condition():
	var has_won = true
	for pair in swap_pairs:
		if pair.can_swap:
			has_won = false
			break
	
	if has_won:
		print("FELICIDADES, GANASTE!")
		
		# 1.Apagamos el procesamiento de input
		set_process_unhandled_input(false)
		
		# 2.Calculamos la puntuacion final como antes
		var bonus = 0
		match lives:
			5: bonus = 500
			4: bonus = 300
			3: bonus = 150
			2: bonus = 50
			1: bonus = 10
			_: bonus = 0
		
		score += bonus
		print("Bonus de ", bonus, " puntos por terminar con ", lives, " vidas.")
		print("Puntuacion final: ", score)
		
		# 3.Guardamos los datos para la pantalla final
		TimerData.tiempo_total = time
		TimerData.lives = lives
		TimerData.score = score
		
		# 4.Iniciamos la secuencia de victoria con pausas
		await victory_sequence()

#SECUENCIA DE VICTORIA
func victory_sequence():
	#Pausa el juego por 2 segundos
	await get_tree().create_timer(2.0).timeout
	print("Pasaron 2 segundos. Mostrando poster...")
	
	#Agregamos una comprobacion de seguridad
	if poster_radagast:
		#Muestra el poster con el efecto de desvanecimiento
		show_victory_poster()
	
	#Pausa el juego por 3 segundos mas (para un total de 5)
	await get_tree().create_timer(3.0).timeout
	print("Pasaron 5 segundos en total. Cambiando de escena...")
	
	#Cambia a la escena de victoria
	get_tree().change_scene_to_file("res://Escenas/ganaste.tscn")

#Funcion que muestra el poster con una animacion
func show_victory_poster():
	#Creamos una animacion (Tween)
	var tween = create_tween()
	#Animamos la propiedad 'modulate:a' (transparencia) de 0 a 1 en 1.5 segundos
	tween.tween_property(poster_radagast, "modulate:a", 1.0, 1.5)

#FUNCIONES DEL SISTEMA DE VIDAS
func lose_a_life():
	lives -= 1
	update_lives_display()
	
	if lives <= 0:
		print("GAME OVER")
		print("Puntuacion final: ", score)
		get_tree().change_scene_to_file("res://Escenas/Perdiste.tscn")
		set_process_unhandled_input(false)
	else:
		print("Vidas restantes: ", lives)

func update_lives_display():
	for i in range(life_icons.size()):
		var life_icon = life_icons[i]
		if i < lives:
			life_icon.visible = true
		else:
			life_icon.visible = false
