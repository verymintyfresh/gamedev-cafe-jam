extends Node2D
class_name MainGame

var current_screen = Vector2i(0,0)
var is_mid_transition = false

static var _instance: MainGame = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.screen_transition.connect(move_screen)
	_instance = self if _instance == null else _instance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player.position.x <= Utils.map_to_coords(current_screen).x:
		if !is_mid_transition:
			EventBus.screen_transition.emit(Vector2i(-1,0))
			#print("Moving screen LEFT")
	elif $Player.position.y <= Utils.map_to_coords(current_screen).y:
		if !is_mid_transition:
			EventBus.screen_transition.emit(Vector2i(0,-1))
			#print("Moving screen UP")
	elif $Player.position.x >= Utils.map_to_coords_bottom_right(current_screen).x:
		if !is_mid_transition:
			EventBus.screen_transition.emit(Vector2i(1,0))
			#print("Moving screen RIGHT")
	elif $Player.position.y >= Utils.map_to_coords_bottom_right(current_screen).y:
		if !is_mid_transition:
			EventBus.screen_transition.emit(Vector2i(0,1))
			#print("Moving screen DOWN")

func move_screen(transform):
	is_mid_transition = true
	
	$Player.set_physics_process(false)
	$Player.set_process_input(false)
		
	current_screen += transform
	var top = Utils.map_to_coords(current_screen).y
	var left = Utils.map_to_coords(current_screen).x
	var bottom = Utils.map_to_coords_bottom_right(current_screen).y
	var right = Utils.map_to_coords_bottom_right(current_screen).x
	
	# Move the camera to the new screen
	var tween
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Player/Camera2D, "limit_left", left, Utils.CAMERA_SPEED)
	tween.tween_property($Player/Camera2D, "limit_right", right, Utils.CAMERA_SPEED)
	tween.tween_property($Player/Camera2D, "limit_top", top, Utils.CAMERA_SPEED)
	tween.tween_property($Player/Camera2D, "limit_bottom", bottom, Utils.CAMERA_SPEED)
	tween.tween_property($ColorRect, "position", Vector2(left,top), Utils.CAMERA_SPEED)


	# Move the player to the side of the new screen
	var target_position = $Player.position
	match transform:
		Vector2i(-1,0): # traveling left, match right of player
			target_position.x = right - 5
		Vector2i(0,-1):
			target_position.y = bottom - 5
		Vector2i(1,0):
			target_position.x = left + 5
		_:
			target_position.y = top + 5
	
	print("Moving from", $Player.position)
	print("Moving to", target_position)
	
	tween.tween_property($Player, "position", target_position, Utils.CAMERA_SPEED)
	await tween.finished
	
	$Player.set_physics_process(true)
	$Player.set_process_input(true)	
	
	is_mid_transition = false

func is_on_ladder(pos) -> bool:
	return Utils.get_custom_data_at($Ladder, pos, "is_ladder")
