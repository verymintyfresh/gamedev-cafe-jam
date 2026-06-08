extends CharacterBody2D
class_name Friend

@export var SPEED = 25.0
@export var WAIT_TIME = 7.0
@export var GRAVITY = 200.0
@export var TERMINAL_VELOCITY = 500.0

@export_multiline var speech: String
@export var anchor_value = -10

@onready var collider = $CollisionShape2D

@export var patrol: Vector2 # left and right sides

var current_patrol_point: float
var reached_patrol: bool
var stopped: bool
var rng

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	$Timer.wait_time = WAIT_TIME
	$Timer.start()
	$SpeechBubble.label = speech
	$SpeechBubble.anchor = Vector2(0, anchor_value)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = min(velocity.y, TERMINAL_VELOCITY)

	# 1. Choose a point in patrol radius
	if not current_patrol_point:
		current_patrol_point = rng.randf_range(patrol.x, patrol.y)
		#print("Got patrol point:", current_patrol_point)
		while abs(current_patrol_point - position.x) < (patrol.y - patrol.x) * 0.4:
			current_patrol_point = rng.randf_range(patrol.x, patrol.y)
			#print("Getting new patrol:", current_patrol_point)
	# 2. Move to that point
	else:
		if not Utils.fuzzy_equals(position.x, current_patrol_point, 1) and not reached_patrol:
			#print("Attempting to move")
			velocity.x = sign(current_patrol_point - position.x) * SPEED
			stopped = false
		elif not stopped:
			#print("Stopping movement")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			reached_patrol = true
	# 3. Wait for WAIT_TIME and delete current patrol point
	if velocity.x == 0:
		$AnimatedSprite2D.play("Idle")
		stopped = true
		#print("Velocity 0, waiting to move")
		await $Timer.timeout
		current_patrol_point = 0
		reached_patrol = false

	move_and_slide()
	player_animations()
	
func player_animations():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("Run")
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Run")

#func _input(event):
	## jumping
	#if can_climb:
		#if (event.is_action_released("ui_up")
		#or event.is_action_released("ui_down")):
			#velocity.y = 0
		#if Input.is_action_pressed("ui_up"):
			#velocity.y = CLIMBING_SPEED
			#is_actually_climbing = true
		#if Input.is_action_pressed("ui_down"):
			#velocity.y = -1 * CLIMBING_SPEED
			#is_actually_climbing = true
	#if event.is_action_pressed("ui_jump") and is_on_floor():
		#velocity.y += JUMP_VELOCITY
		#$AnimatedSprite2D.play("Jump")


func _on_player_entered(player: Player) -> void:
	#print("Player, hello!")
	$SpeechBubble.anchor = Vector2(0, anchor_value)
	$SpeechBubble.spawn()

func _on_player_exited(player: Player) -> void:
	$SpeechBubble.anchor = Vector2(0, anchor_value)
	$SpeechBubble.delete()
