extends CharacterBody2D
class_name Player

@export var SPEED: float
@export var CLIMBING_SPEED: float
@export var JUMP_VELOCITY: float
@export var GRAVITY: float
@export var TERMINAL_VELOCITY: float

@export var bullet: PackedScene

@onready var collider = $CollisionShape2D
@onready var anchor = Vector2(0, -20)

var can_climb: bool = false
var is_actually_climbing: bool = false

var can_shoot: bool = false
var cutscene_finished: bool = false

var facing_left: bool = false

func _ready() -> void:
	$Camera2D.force_update_scroll()
	EventBus.got_macguffin.connect(on_got_macguffin)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_actually_climbing:
		velocity += get_gravity() * delta
		velocity.y = min(velocity.y, TERMINAL_VELOCITY)

	if !MainGame._instance.is_on_ladder(global_position):
		can_climb = false
		is_actually_climbing = false
	else:
		can_climb = true

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
		facing_left = true
		$AnimatedSprite2D.play("Run")
	if Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = false
		facing_left = false
		$AnimatedSprite2D.play("Run")
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("Idle")

func _input(event):
	# jumping
	if can_climb:
		if (event.is_action_released("ui_up")
		or event.is_action_released("ui_down")):
			velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = CLIMBING_SPEED
			is_actually_climbing = true
		if Input.is_action_pressed("ui_down"):
			velocity.y = -1 * CLIMBING_SPEED
			is_actually_climbing = true
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump")
	if Input.is_key_pressed(KEY_ENTER) and can_shoot:
		if not cutscene_finished:
			EventBus.macguffin_cutscene_finished.emit()
			cutscene_finished = true
		print("Pew!")
		shoot()
		
func shoot():
	if get_tree().get_nodes_in_group("player_bullets").size() <= 3:
		var b = bullet.instantiate()
		if facing_left:
			b.speed *= -1
		b.add_to_group("player_bullets")
		owner.add_child(b)
		b.transform = $Marker2D.global_transform

func on_got_macguffin():
	print("Got Macguffin")
	set_physics_process(false)
	set_process_input(false)
	$AnimatedSprite2D.play("Idle")
	velocity.y = 0
	
	anchor = anchor + global_position
	await get_tree().create_timer(4).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(4.331, 0.0, 4.193), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween.kill()
	set_process_input(true)
	JUMP_VELOCITY -= 100
	can_shoot = true
	await EventBus.macguffin_cutscene_finished
	#await get_tree().create_timer(1).timeout
	set_physics_process(true)
	return
