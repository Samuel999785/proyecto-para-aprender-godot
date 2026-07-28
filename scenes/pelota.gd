extends RigidBody2D

# Fuerza de movimiento
@export var fuerza: float = 500.0
@export var velocidad_giro: float = 3.0  # Ajusta este valor si gira muy rápido o muy lento

# Nombres de las acciones en el Input Map
@export var accion_arriba: String = "move_up"
@export var accion_abajo: String = "move_down"
@export var accion_izquierda: String = "move_left"
@export var accion_derecha: String = "move_right"

# --- VARIABLES PARA EL COLOR ---
# Referencia al viewport para saber el tamaño de la pantalla
var tamano_pantalla: Vector2

# Definimos los colores base
var color_izquierda = Color.BLACK
var color_derecha = Color.WHITE

# --- VARIABLES PARA EL RASTRO ---
@export var max_puntos_rastro: int = 50
@onready var linea_rastro = $Rastros/RastroColores
# --------------------------------

func _ready():
	# Obtenemos el tamaño de la ventana de juego al iniciar
	tamano_pantalla = get_viewport_rect().size
	
	# Preparamos la línea del rastro para que no siga directamente al objeto
	if linea_rastro:
		linea_rastro.top_level = true
		linea_rastro.clear_points()

func _physics_process(delta):
	# --- 1. ROTACIÓN (Usando velocidad angular para la física) ---
	var rotacion_input = 0.0
	if Input.is_action_pressed(accion_derecha):
		rotacion_input += 1.0
	if Input.is_action_pressed(accion_izquierda):
		rotacion_input -= 1.0

	# Aplicamos velocidad angular directamente (en radianes por segundo)
	# Esto permite que la física mantenga el ángulo actual cuando sueltas el botón
	angular_velocity = rotacion_input * velocidad_giro

	# --- 2. AVANCE Y RETROCESO ---
	var avance_input = 0.0
	if Input.is_action_pressed(accion_arriba):
		avance_input += 1.0
	if Input.is_action_pressed(accion_abajo):
		avance_input -= 1.0

	# Usamos transform.x (el vector que apunta hacia adelante)
	var direccion_avance = transform.x * avance_input
	apply_force(direccion_avance * fuerza)

	# --- ACTUALIZAR COLOR ---
	actualizar_color_por_posicion()
	
	# --- ACTUALIZAR RASTRO ---
	actualizar_rastro()

# Función que calcula y aplica el color según la posición
func actualizar_color_por_posicion():
	# 1. Calculamos la posición X relativa (de 0.0 a 1.0)
	var x_relativa = global_position.x / tamano_pantalla.x
	
	# Aseguramos que el valor esté entre 0 y 1
	x_relativa = clamp(x_relativa, 0.0, 1.0)
	
	# 2. Interpolamos el color
	var color_final: Color = color_izquierda.lerp(color_derecha, x_relativa)
	
	# 3. Aplicamos el color al nodo
	self.modulate = color_final

# Función que dibuja la estela del rastro
func actualizar_rastro():
	if linea_rastro:
		linea_rastro.add_point(global_position)
		if linea_rastro.get_point_count() > max_puntos_rastro:
			linea_rastro.remove_point(0)
