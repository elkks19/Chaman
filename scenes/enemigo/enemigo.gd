extends CharacterBody2D

@export var speed = 60
@export var health = 1
@export var attack_damage = 1  # Daño que hace el enemigo
@export var attack_range = 50.0  # Rango de ataque cuerpo a cuerpo
@export var attack_cooldown = 2.0  # Enfriamiento del ataque en segundos
var player_chase = false
var player = null
var can_attack = true  # Controla si el enemigo puede atacar

signal kill

# Temporizador para el enfriamiento de ataque
func _ready():
	var attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.connect("timeout", _on_attack_cooldown_finished)
	add_child(attack_timer)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if player_chase and player:
		# Moverse hacia el jugador
		position += (player.position - position).normalized() * speed * delta
		
		# Si el enemigo está dentro del rango de ataque y puede atacar
		if (player.position - position).length() <= attack_range and can_attack:
			_attack_player()

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		kill.connect(player._on_enemigo_kill_)
		player_chase = true

func _on_area_2d_body_exited(body):
	player = null
	player_chase = false

# Función para atacar al jugador
func _attack_player():
	if player and can_attack:
		player.take_damage(attack_damage)  # Aplicar daño al jugador
		_play_animation("attack")  # Reproducir animación de ataque
		can_attack = false  # Iniciar enfriamiento del ataque
		$Timer.start()

# Fin del enfriamiento del ataque
func _on_attack_cooldown_finished():
	can_attack = true  # El enemigo puede volver a atacar después del enfriamiento

# Recibir daño
func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

# Muerte del enemigo
func die():
	_play_animation("death")
	kill.emit()
	queue_free()

# Función para reproducir animaciones
func _play_animation(name):
	$AnimatedSprite2D.play(name)
