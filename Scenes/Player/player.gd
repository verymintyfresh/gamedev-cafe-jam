extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -1000.0
@export var GRAVITY = 200.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	player_animations()
	
func player_animations():
	if Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("Run")
	if Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Run")
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("Idle")

func _input(event):
	# jumping
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump")
