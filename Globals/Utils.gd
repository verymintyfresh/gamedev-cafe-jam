extends Node

@export var SCREEN_WIDTH = 320
@export var SCREEN_HEIGHT = 176

func coords_to_map(coords):
	return Vector2i(coords.x / SCREEN_WIDTH, coords.y / SCREEN_HEIGHT)

func map_to_coords(coords):
	return Vector2(coords.x * SCREEN_WIDTH, coords.y * SCREEN_HEIGHT)

func map_to_coords_bottom_right(coords):
	return map_to_coords(coords) + Vector2(SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1)
