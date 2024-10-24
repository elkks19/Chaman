# Personaje principal (Player.gd)
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

var score = 0
var health = 5  # Vida del personaje

var attack_animation_ended = true
var can_move = true
var current_animation = ""
@export var attack_damage = 1  # Daño que hace el personaje al atacar
@export var attack_range = 100.0  # Rango del ataque del personaje

func _attack_enemy():
	var enemies_in_range = get_enemies_in_attack_range()
	for enemy in enemies_in_range:
		enemy.take_damage(attack_damage)

# Detectar enemigos cercanos para hacer daño
func get_enemies_in_attack_range():
	var enemies_in_range = []
	# Obtener todos los nodos en la escena y filtrar por enemigos
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if (enemy.position - position).length() <= attack_range:
			enemies_in_range.append(enemy)
	return enemies_in_range

signal update_health 
signal update_score

func _physics_process(delta):
	# Solo aplicar movimiento y salto si se puede mover
	if can_move:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event):
	# Solo si el personaje puede moverse y está en el suelo
	if can_move and is_on_floor():
		if Input.is_action_pressed("move_left"):
			_play_animation("run")
			$AnimatedSprite2D.flip_h = true

		elif Input.is_action_pressed("move_right"):
			_play_animation("run")
			$AnimatedSprite2D.flip_h = false

		# Comenzar ataque si no está atacando y está en el suelo
		elif Input.is_action_just_pressed("attack") and attack_animation_ended:
			attack_animation_ended = false
			can_move = false  # Bloquear movimiento durante el ataque
			_play_animation("attack")

	# Volver a idle si no se está moviendo ni atacando
	if can_move and not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right") and attack_animation_ended:
		_play_animation("iddle")

func _on_animated_sprite_2d_animation_finished():
	if current_animation == "attack":
		_attack_enemy()
		attack_animation_ended = true
		can_move = true  # Permitir movimiento otra vez
	_play_animation("iddle")

func _play_animation(name):
	if current_animation != name:
		current_animation = name
		$AnimatedSprite2D.play(name)


func take_damage(amount):
	health -= amount
	update_health.emit(health)
	if health <= 0:
		die()

func die():
	# Reproducir animación de muerte o cualquier otro comportamiento
	_play_animation("death")
	queue_free()

func _on_alma_picked():
	score += 15
	update_score.emit(score)

func _on_enemigo_kill_():
	score += 10
	update_score.emit(score)
