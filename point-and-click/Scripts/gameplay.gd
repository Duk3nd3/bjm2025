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

#VARIABLES DE ESTADO DEL JUEGO
var swap_pairs = []
var lives = 5
var time = 0
var score = 0 #Puntaje inicial

func _ready():
	print("Juego iniciado. Tenes 5 vidas.")
	
	life_icons.clear()
	for child in lives_container.get_children():
		if child is Sprite2D:
			life_icons.append(child)
		else:
			print("OJO: Se encontro un nodo que no es Sprite2D en LivesContainer: ", child.name)
	
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
					
					#Sumamos puntos por el acierto
					score += 100
					print("Puntuacion: ", score)
					
					#CODIGO DE INTERCAMBIO
					#Guardamos la posicion Y la rotacion del sprite principal
					var temp_pos = pair.main_sprite.position
					var temp_rot = pair.main_sprite.rotation

					#Movemos y rotamos el sprite principal a la posicion y rotacion del sprite gris
					pair.main_sprite.position = pair.gray_sprite.position
					pair.main_sprite.rotation = pair.gray_sprite.rotation

					#Movemos y rotamos el sprite gris a la posicion y rotacion que guardamos
					pair.gray_sprite.position = temp_pos
					pair.gray_sprite.rotation = temp_rot
					#FIN DEL CÓDIGO CORREGIDO
					
					pair.can_swap = false
					
					#Despues de un intercambio, comprobamos si se ha ganado
					check_victory_condition()
					
				else:
					print("Este icono (", pair.main_sprite.name, ") ya fue intercambiado.")
				
				break

		if not hit_detected:
			print("ERRASTE! Perdes una vida.")
			lose_a_life()

#FUNCION PARA COMPROBAR LA VICTORIA
func check_victory_condition():
	#Asumimos que el jugador gano
	var has_won = true
	
	#Recorremos todos los pares. Si encontramos uno que todavia se puede intercambiar,
	#significa que el jugador aun no ha ganado
	for pair in swap_pairs:
		if pair.can_swap:
			has_won = false
			break #Salimos del bucle, no hay necesidad de seguir comprobando
	
	#Si despues de revisar todos los pares, 'has_won' sigue siendo true...
	if has_won:
		TimerData.tiempo_total = time
		get_tree().change_scene_to_file("res://Escenas/ganaste.tscn")
		print("FELICIDADES, GANASTE!")
		
		#LOGICA DE BONIFICACION POR VIDAS
		var bonus = 0
		
		#usamos 'match' para asignar un bonus segun las vidas restantes
		match lives:
			5:
				bonus = 500 #Bonus Perfecto
			4:
				bonus = 300
			3:
				bonus = 150
			2:
				bonus = 50
			1:
				bonus = 10 #Bonus Milagroso xD
			_: #Este es el caso por defecto, si 'lives' es 0 o cualquier otro valor
				bonus = 0
		
		#Sumamos el bonus a la puntuacion
		score += bonus
		TimerData.lives = lives
		print("Bonus de ", bonus, " puntos por terminar con ", lives, " vidas.")
		TimerData.score = score
		print("Puntuacion final: ", score)
		
		#Apagamos el procesamiento de input para que no se puedan perder mas vidas
		set_process_unhandled_input(false)

#FUNCIONES DEL SISTEMA DE VIDAS
func lose_a_life():
	lives -= 1
	update_lives_display()
	
	if lives <= 0:
		print("GAME OVER")
		print("Puntuacion final: ", score)
		#Apagamos el procesamiento de input
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
