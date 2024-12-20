extends Area2D

@export var area_camera: PhantomCamera2D

func _ready() -> void:
	connect("body_entered", _entered_body)
	connect("body_exited", _exited_body)

func _entered_body(body: PhysicsBody2D) -> void:
	if body == PlayerState.cur_interact_body:
		area_camera.set_priority(10)

func _exited_body(body: PhysicsBody2D) -> void:
	if body == PlayerState.cur_interact_body:
		area_camera.set_priority(0)
