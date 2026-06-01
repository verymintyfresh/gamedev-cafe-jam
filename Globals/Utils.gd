extends Node

@export var SCREEN_WIDTH = 320
@export var SCREEN_HEIGHT = 176
@export var CAMERA_SPEED = 0.6

func coords_to_map(coords):
	return Vector2i(coords.x / SCREEN_WIDTH, coords.y / SCREEN_HEIGHT)

func map_to_coords(coords):
	return Vector2(coords.x * SCREEN_WIDTH, coords.y * SCREEN_HEIGHT)

func map_to_coords_bottom_right(coords):
	return map_to_coords(coords) + Vector2(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1)

#func get_player_bottom_right(player: Player):
#	return Vector2(player.position.x + player.collider.shape.size.x,
#				   player.position.y + player.collider.shape.size.y)

func measure_player_screen_bottom_right(screen: Vector2i, player: Player):
	return map_to_coords(screen) - Vector2(player.collider.shape.size.x,player.collider.shape.size.y)
