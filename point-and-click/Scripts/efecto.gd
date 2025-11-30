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

func _process(delta):
	tiempo += delta
	var t = tiempo / duracion_total

	# -------------------------------
	# FASE 0: reflectores entran
	# -------------------------------
	if t < 0.33:
		var k = t / 0.33

		
		

		# Mover hacia el centro
		#$SpotLeft.position.x = lerp(-spot_tamaño.x, size.x * 0.35, k)
		#$SpotRight.position.x = lerp(size.x, size.x * 0.65, k)
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
