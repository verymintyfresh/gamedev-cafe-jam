extends Area2D
class_name Macguffin

@export var wobble_range = 12
@export var wobble_speed = 12

enum State {WOBBLE_UP, WOBBLE_DOWN}

var initial_position
var current_state = State.WOBBLE_DOWN
var progress = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = position.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _physics_process(delta: float) -> void:
	#match current_state:
		#State.WOBBLE_UP:
			#progress += delta
			#position.y = lerp(initial_position, initial_position - wobble_range, progress / (wobble_range / wobble_speed))
			#if progress >= (wobble_range / wobble_speed):
				#switch_state(State.WOBBLE_DOWN)
		#State.WOBBLE_DOWN:
			#progress -= delta
			#position.y = lerp(initial_position, initial_position - wobble_range, progress / (wobble_range / wobble_speed))
			#if progress <= 0:
				#switch_state(State.WOBBLE_UP)

func _on_player_entered(body: Player) -> void:
	EventBus.got_macguffin.emit() # Replace with function body.
	await get_tree().create_timer(1).timeout
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "global_position", body.anchor, 2.0)
	tween.tween_property(self, "scale", Vector2(0.2, 0.2), 2.0)
	await tween.finished
	tween.kill()
	await get_tree().create_timer(1).timeout
	tween = create_tween().set_parallel()
	tween.tween_property(self, "global_position", global_position + Vector2(0,30), 1.0)
	tween.tween_property(self, "scale", Vector2.ZERO, 1.0)
	await tween.finished

#func switch_state(new_state):
	#current_state = new_state
	#match new_state:
		#State.WOBBLE_UP:
			#progress = 0.0
		#State.WOBBLE_DOWN:
			#progress = wobble_range / wobble_speed
