extends MarginContainer
class_name SpeechBubble

@export var SCALE_TIME = 0.1

@onready var label = %Text:
	set(text):
		label.text = text
		max_size = size

var anchor: Vector2:
	set(value):
		position = value - Vector2(max_size.x/2,max_size.y)
		top_left = position
var max_size: Vector2
var top_left: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#max_size = size
	hide()

func delete() -> void:
	%Text.hide()
	var target = Vector2(0, (top_left.y + max_size.y) / 2)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self, "position", target, SCALE_TIME).from(top_left)
	tween.parallel().tween_property(self, "size:x", 0, SCALE_TIME).from(size.x)
	tween.parallel().tween_property(self, "size:y", 0, SCALE_TIME).from(size.y)
	await tween.finished
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn() -> void:
	show()
	position = anchor - Vector2(0,max_size.y/2)
	#size = Vector2.ZERO
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self, "position", top_left, SCALE_TIME).from(position)
	tween.parallel().tween_property(self, "size:x", max_size.x, SCALE_TIME).from(0)
	tween.parallel().tween_property(self, "size:y", max_size.y, SCALE_TIME).from(0)
	await tween.finished
	%Text.show()
	#show()
