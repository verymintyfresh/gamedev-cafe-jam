extends MarginContainer
class_name SpeechBubble

@export var SCALE_TIME = 0.1

@onready var label = %Text:
	set(text):
		label.text = text

var anchor: Vector2 
var max_size: Vector2
var top_left: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#max_size = size
	hide()

func delete() -> void:
	%Text.hide()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(0,0), SCALE_TIME).from(Vector2(1,1))
	await tween.finished
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn() -> void:
	show()
	%Text.hide()
	position = anchor - Vector2(size.x/2,size.y)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(1,1), SCALE_TIME).from(Vector2(0,0))
	await tween.finished
	%Text.show()
	#show()
