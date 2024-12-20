extends CanvasLayer

@onready var cgs = $CGs
@onready var animation = $AnimationPlayer
@onready var fading_node = $Fading

@export var story_name:String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	story_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func story_start():
	PlayerState.story_action.connect(on_story_action)
	PlayerState.show_main_dialogue_balloon("story_dialog/new_game","p1")

func on_story_action():
	var cg = cgs.get_child(-1)
	if cg:
		cg.reparent(fading_node)
		animation.play("glowblur")
		await(animation.animation_finished)
		cg.queue_free()
	else:
		PlayerState.story_action.disconnect(on_story_action)
		queue_free()
