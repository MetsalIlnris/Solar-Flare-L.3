extends "res://scene/map_scene.gd"

@onready var one = $"Characters/16180"
@onready var yan = $"Characters/yan"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yan.switch_size(0.8)
	one.switch_size(0.8)
	one.control()
	for w in $Characters/w.get_children():
		w.switch_size(0.6)
		w.wash()
	for c in $Characters/RayCast2D.get_children():
		c.switch_size(0.8)
		c.wander()
	await(get_tree().create_timer(2).timeout)
	var tween = get_tree().create_tween()
	tween.tween_property($ParallaxFront/BlockLayer/Train,"position",Vector2(-2000,-1477),5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
