extends Area2D

@export var velocidad: float = 800.0

func _process(delta):
	# La bala avanza siempre hacia la derecha local (transform.x)
	position += transform.x * velocidad * delta

# Para que la bala se borre sola al salir de la pantalla
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
