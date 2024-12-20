extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.show_main_dialogue_balloon("world_dialog/sun","death")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
