extends Control

@export var duracion_total := 3.0   # segundos
@export var intensidad_final := 1.0 # brillo final
@export var altura_spot := 0.6      # altura relativa del foco
@export var spot_tamaño := Vector2(400, 800)

var tiempo := 0.0
var fase := 0  # 0 = entrada, 1 = foco central, 2 = fade final

func _ready():
	# Pantalla negra inicial
	$OverlayNegro.color = Color(0,0,0,1)
	# Configurar reflectores
	$SpotLeft.modulate.a = 0
	$SpotRight.modulate.a = 0

	$SpotLeft.size = spot_tamaño
	$SpotRight.size = spot_tamaño

	# Posiciones iniciales fuera de pantalla
	$SpotLeft.position = Vector2(-spot_tamaño.x, size.y * altura_spot)
	$SpotRight.position = Vector2(size.x, size.y * altura_spot)

func _process(delta):
	tiempo += delta
	var t = tiempo / duracion_total

	# -------------------------------
	# FASE 0: reflectores entran
	# -------------------------------
	if t < 0.33:
		var k = t / 0.33

		$SpotLeft.modulate.a = k
		$SpotRight.modulate.a = k

		# Mover hacia el centro
		$SpotLeft.position.x = lerp(-spot_tamaño.x, size.x * 0.35, k)
		$SpotRight.position.x = lerp(size.x, size.x * 0.65, k)
		print("reflector der", $SpotLeft.position.x)
	# -------------------------------
	# FASE 1: reflectores se centran
	# -------------------------------
	elif t < 0.66:
		var k = (t - 0.33) / 0.33

		$SpotLeft.position.x = lerp(size.x * 0.35, size.x * 0.45, k)
		$SpotRight.position.x = lerp(size.x * 0.65, size.x * 0.55, k)

	# -------------------------------
	# FASE 2: fade in general
	# -------------------------------
	else:
		var k = (t - 0.66) / 0.34

		# La pantalla negra se desvanece
		$OverlayNegro.color.a = lerp(1.0, 0.0, k)

		# Aumentar la intensidad de los reflectores
		$SpotLeft.modulate.a = lerp(1.0, 0.2, k)
		$SpotRight.modulate.a = lerp(1.0, 0.2, k)

		if k >= 1:
			set_process(false) # Finaliza el efecto
