extends Area2D
class_name Bullet

var speed = 750

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bullet_hit(body: Node2D) -> void:
	if body is Boss:
		EventBus.bullet_hit_boss.emit()
	queue_free()
