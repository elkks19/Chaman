# Main.gd (Escena principal para pruebas)
# Controlador principal de la escena (Game.gd)
extends Node2D

const enemy_scene = preload("res://scenes/enemigo/Enemigo.tscn")
const alma_scene = preload("res://scenes/alma/Alma.tscn")
@export var min_spawn_interval = 2.0  # Tiempo mínimo entre spawns
@export var max_spawn_interval = 5.0  # Tiempo máximo entre spawns

# Referencia a la cámara que sigue al jugador
@onready var camera = $Camera2D

func _ready():
	# Iniciar la primera generación de enemigos y almas
	_schedule_next_enemy_spawn()
	_schedule_next_alma_spawn()

# Programar la aparición del siguiente enemigo
func _schedule_next_enemy_spawn():
	var spawn_time = randf_range(min_spawn_interval, max_spawn_interval)
	await get_tree().create_timer(spawn_time).timeout
	_spawn_enemy()
	_schedule_next_enemy_spawn()  # Volver a programar la próxima generación

# Programar la aparición del siguiente alma
func _schedule_next_alma_spawn():
	var spawn_time = randf_range(min_spawn_interval, max_spawn_interval)
	await get_tree().create_timer(spawn_time).timeout
	_spawn_alma()
	_schedule_next_alma_spawn()  # Volver a programar la próxima generación

# Generar un enemigo dentro de la cámara
func _spawn_enemy():
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.scale = Vector2(3, 3)
	var spawn_position = _get_random_spawn_position_in_camera()
	enemy_instance.position = spawn_position
	add_child(enemy_instance)

# Generar un alma dentro de la cámara
func _spawn_alma():
	var alma_instance = alma_scene.instantiate()
	var spawn_position = _get_random_spawn_position_in_camera()
	alma_instance.position = spawn_position
	add_child(alma_instance)

@onready var floor_y = $Floor.position.y # Altura del piso, ajusta este valor según la altura del suelo en tu juego

func _get_random_spawn_position_in_camera():
	# Obtener la posición global de la cámara
	var camera_position = camera.global_position
	
	# Obtener el tamaño visible del viewport
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Calcular las coordenadas límite del área visible de la cámara en el eje X
	var min_x = camera_position.x - viewport_size.x / 2
	var max_x = camera_position.x + viewport_size.x / 2
	
	# Generar una posición aleatoria en el eje X dentro del área visible de la cámara
	var random_x = randf_range(min_x, max_x)
	
	# La posición en Y será constante, al nivel del piso
	var y_position = floor_y
	
	return Vector2(random_x, y_position)





func _on_main_character_update_health(health):
	$Camera2D/HealthLabel.text = '❤️ ' + str(health)

func _on_main_character_update_score(score):
	$Camera2D/ScoreLabel.text = str(score)
