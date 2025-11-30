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

# Referencias a las cortinas y al poster
@onready var cortina_izquierda: Sprite2D = $CortinaIzquierda
@onready var cortina_derecha: Sprite2D = $CortinaDerecha
@onready var poster_radagast: Sprite2D = $PosterRadagast

#VARIABLES DE ESTADO DEL JUEGO
var swap_pairs = []
var lives = 5
var time = 0
var score = 0 #Puntaje inicial

func _ready():
	print("Juego iniciado. Tenes 5 vidas.")
	
	# Preparamos el poster para que aparezca con un efecto de desvanecimiento
	if poster_radagast:
		poster_radagast.modulate.a = 0.0 # Lo hacemos completamente transparente
		poster_radagast.visible = true
	
	life_icons.clear()
	for child in lives_container.get_children():
		if child is Sprite2D:
			life_icons.append(child)
		else:
			print("ADVERTENCIA: Se encontro un nodo que no es Sprite2D en LivesContainer: ", child.name)
	
	swap_pairs = [
		{"main_sprite": galeraColor, "gray_sprite": galeraGris, "can_swap": true},
		{"main_sprite": varitaColor, "gray_sprite": varitaGris, "can_swap": true},
		{"main_sprite": capaColor, "gray_sprite": capaGris, "can_swap": true}
	]
	
	update_lives_display()

func _process(delta):
	time += delta

# --- NUEVA FUNCIÓN AUXILIAR PARA DETECCIÓN PRECISA ---
# Comprueba si un clic del mouse cayó sobre un píxel no transparente de un sprite
func _is_click_on_sprite(sprite: Sprite2D, mouse_pos: Vector2) -> bool:
	# 1. Obtenemos la textura del sprite
	var texture = sprite.texture
	if not texture:
		return false # Si no tiene textura, no se puede hacer clic
	
	# 2. Convertimos la posición global del mouse a coordenadas locales del sprite
	var local_pos = sprite.to_local(mouse_pos)
	
	# 3. Obtenemos el rectángulo del sprite para comprobar los límites
	var rect = sprite.get_rect()
	
	# 4. Si el clic está fuera del rectángulo del sprite, devolvemos falso
	if not rect.has_point(local_pos):
		return false
		
	# 5. Obtenemos la imagen de la textura
	var image = texture.get_image()
	
	# 6. Convertimos las coordenadas locales a coordenadas de píxel en la imagen
	var pixel_coords = Vector2i(
		int(local_pos.x / rect.size.x * image.get_width()),
		int(local_pos.y / rect.size.y * image.get_height())
	)
	
	# 7. Obtenemos el color del píxel en esas coordenadas
	var pixel_color = image.get_pixel(pixel_coords.x, pixel_coords.y)
	
	# 8. Devolvemos verdadero solo si el píxel no es transparente (alfa > 0)
	return pixel_color.a > 0.1 # Usamos un pequeño umbral por si acaso

# --- FUNCIÓN _unhandled_input MODIFICADA ---
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		var mouse_pos = get_global_mouse_position()
		var hit_detected = false
		
		for pair in swap_pairs:
			# MODIFICADO: Usamos nuestra nueva función de detección precisa
			if _is_click_on_sprite(pair.main_sprite, mouse_pos):
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

# --- El resto de tu código se queda igual ---

# --- LÓGICA DE VICTORIA CON ANIMACIÓN DE CORTINAS ---
func check_victory_condition():
	var has_won = true
	for pair in swap_pairs:
		if pair.can_swap:
			has_won = false
			break
	
	if has_won:
		print("¡FELICIDADES, GANASTE!")
		set_process_unhandled_input(false)
		
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
		
		TimerData.tiempo_total = time
		TimerData.lives = lives
		TimerData.score = score
		
		await victory_sequence()

func victory_sequence():
	await get_tree().create_timer(2.0).timeout
	print("Han pasado 2 segundos. Abriendo cortinas...")
	
	open_curtains()
	show_victory_poster()
	
	await get_tree().create_timer(3.0).timeout
	print("Han pasado 5 segundos en total. Cambiando de escena...")
	
	get_tree().change_scene_to_file("res://Escenas/ganaste.tscn")

func open_curtains():
	if cortina_izquierda and cortina_derecha:
		var tween = create_tween()
		tween.parallel().tween_property(cortina_izquierda, "position:x", cortina_izquierda.position.x - 500, 1.5)
		tween.parallel().tween_property(cortina_derecha, "position:x", cortina_derecha.position.x + 500, 1.5)
	else:
		print("ADVERTENCIA: No se encontraron los nodos de las cortinas para animar.")

func show_victory_poster():
	if poster_radagast:
		var tween = create_tween()
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
