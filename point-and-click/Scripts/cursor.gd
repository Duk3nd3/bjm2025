extends Sprite2D

@export var stiffness: float = 18.0     # Fuerza con la que el sprite "tira" hacia el mouse
@export var damping: float = 2.0        # Resistencia que controla cuánto rebota
var velocity: Vector2 = Vector2.ZERO    # Velocidad interna del resorte

func _process(delta: float) -> void:
	var target = get_global_mouse_position()

	# Diferencia entre la posición actual y la deseada
	var offset = target - global_position

	# Ley de Hooke: fuerza = stiffness * estiramiento
	var force = offset * stiffness

	# Ecuación del resorte: aplicar fuerza y amortiguación
	velocity += force * delta
	velocity -= velocity * damping * delta

	# Aplicar movimiento
	global_position += velocity * delta
