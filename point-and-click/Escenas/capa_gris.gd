extends Sprite2D

@export var times := 10   # número de parpadeos
@export var duration := 0.5

func _ready():
	blink_times(times)

func blink_times(count):
	var tw = create_tween()

	for i in count:
		tw.tween_property(self, "modulate:a", 0.0, duration)
		tw.tween_property(self, "modulate:a", 1.0, duration)
