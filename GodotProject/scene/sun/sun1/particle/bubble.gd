extends Node2D

var direction = Vector2(-1,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await(get_tree().create_timer(5).timeout)
	queue_free()

func init(di:Vector2,id:int = randi_range(1,4)):
	direction = di
	for img in get_children():
		if img.name == str(id):
			img.show()
		elif img.is_class("Node2D"):
			img.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 80 * direction.x * delta
	position.y += 80 * direction.y * delta
	rotate(2 * delta)
