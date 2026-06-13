extends CharacterBody2D
class_name Boss

const SPEED = 400.0
const JUMP_VELOCITY = -600.0

@export var HEALTH = 50

var rng: RandomNumberGenerator
var was_jumping: bool = false

func _ready() -> void:
	EventBus.bullet_hit_boss.connect(got_hit)
	EventBus.got_to_boss.connect(hello)
	rng = RandomNumberGenerator.new()
	rng.randomize()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if velocity.y == 0 and velocity.x != 0:
		velocity.x = 0 

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func got_hit():
	var oldcolor = Color(4.331, 0.0, 4.193)
	modulate = Color("306230")
	await get_tree().create_timer(0.05).timeout
	modulate = oldcolor	
	
	HEALTH -= 1


func choose_ai() -> void:
	var myspeed := randf_range(0,1)
	var direction = sign(owner.find_child("Player").global_position.x - global_position.x)
	if direction:
		velocity.y = JUMP_VELOCITY
		velocity.x = direction * myspeed * SPEED
		print(velocity)
	was_jumping = true
	
func hello() -> void:
	$Timer.start()
