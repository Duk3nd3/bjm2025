extends Node2D

# --- REFERENCIAS A LOS ICONOS DEL JUEGO ---
@onready var blue_icon: Sprite2D = $BlueIcon
@onready var gray_icon1: Sprite2D = $GrayIcon1
@onready var green_icon: Sprite2D = $GreenIcon
@onready var gray_icon2: Sprite2D = $GrayIcon2
@onready var red_icon: Sprite2D = $RedIcon
@onready var gray_icon3: Sprite2D = $GrayIcon3

# --- REFERENCIAS A LOS ICONOS DE VIDA ---
@onready var lives_container: HBoxContainer = $LivesContainer
var life_icons: Array[Sprite2D] = []

# --- VARIABLES DE ESTADO DEL JUEGO ---
var swap_pairs = []
var lives = 5
var score = 0 # Variable para la puntuacion

func _ready():
	print("Juego iniciado. Tenes 5 vidas.")
	
	life_icons.clear()
	for child in lives_container.get_children():
		if child is Sprite2D:
			life_icons.append(child)
		else:
			print("ADVERTENCIA: Se encontro un nodo que no es Sprite2D en LivesContainer: ", child.name)
	
	swap_pairs = [
		{"main_sprite": blue_icon, "gray_sprite": gray_icon1, "can_swap": true},
		{"main_sprite": green_icon, "gray_sprite": gray_icon2, "can_swap": true},
		{"main_sprite": red_icon, "gray_sprite": gray_icon3, "can_swap": true}
	]
	
	update_lives_display()

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
					print("¡ACERTASTE en el icono ", pair.main_sprite.name, "!")
					
					# Sumamos puntos por el acierto
					score += 100
					print("Puntuacion: ", score)
					
					var temp_pos = pair.main_sprite.position
					pair.main_sprite.position = pair.gray_sprite.position
					pair.gray_sprite.position = temp_pos
					pair.can_swap = false
					
					# Despues de un intercambio, comprobamos si se ha ganado
					check_victory_condition()
					
				else:
					print("Este icono (", pair.main_sprite.name, ") ya fue intercambiado.")
				
				break

		if not hit_detected:
			print("¡ERRASTE! Perdes una vida.")
			lose_a_life()

# --- FUNCION PARA COMPROBAR LA VICTORIA ---
func check_victory_condition():
	# Asumimos que el jugador ha ganado
	var has_won = true
	
	# Recorremos todos los pares. Si encontramos uno que todavia se puede intercambiar,
	# significa que el jugador aun no ha ganado.
	for pair in swap_pairs:
		if pair.can_swap:
			has_won = false
			break # Salimos del bucle, no hay necesidad de seguir comprobando
	
	# Si despues de revisar todos los pares, 'has_won' sigue siendo true...
	if has_won:
		print("¡FELICIDADES, HAS GANADO!")
		print("Puntuacion final: ", score)
		# MODIFICADO: Apagamos el procesamiento de input para que no se puedan perder mas vidas
		set_process_unhandled_input(false)

# --- FUNCIONES DEL SISTEMA DE VIDAS ---

func lose_a_life():
	lives -= 1
	update_lives_display()
	
	if lives <= 0:
		print("GAME OVER")
		print("Puntuacion final: ", score)
		# Apagamos el procesamiento de input
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
