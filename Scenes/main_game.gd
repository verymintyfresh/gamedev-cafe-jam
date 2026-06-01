extends Node2D

var current_screen = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (
		$Player.position.x <= Utils.map_to_coords(current_screen).x 
		or $Player.position.y <= Utils.map_to_coords(current_screen).y 
		or $Player.position.x >= Utils.map_to_coords_bottom_right(current_screen).x 
		or $Player.position.y >= Utils.map_to_coords_bottom_right(current_screen).y
	):
		EventBus.screen_transition.emit(Utils.coords_to_map($Player.position))
		print("Emitting transition signal:", Utils.coords_to_map($Player.position))
