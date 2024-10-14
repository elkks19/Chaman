extends CharacterBody2D
@onready var animations = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collision_point = collision_info.get_position()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		animations.play("correr")
	else:
		animations.play("iddle")
		
func _input(event):
	if event.is_action_pressed("move_left"):
		animations.flip_h = true
	elif event.is_action_pressed("move_right"):
		animations.flip_h = false
