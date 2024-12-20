extends CanvasLayer

@onready var animator = $AnimationPlayer
@onready var curtain = $curtain
var previous_scene:Node

signal change_finish

func _ready():
	self.hide()

func change_scene(path):
	self.show()
	self.set_layer(999)
	animator.play("fade_in")
	await(animator.animation_finished)
	get_tree().change_scene_to_file(path)
	PlayerState.inputLock = 1
	change_finish.emit()
	animator.play_backwards("fade_in")
	await(animator.animation_finished)
	self.hide()
	self.set_layer(-1)

func change_fight_scene(path):
	self.show()
	self.set_layer(999)
	animator.play("fade_in")
	await(animator.animation_finished)
	previous_scene = get_tree().current_scene
	var fight_scene = load(path).instantiate()
	get_tree().root.remove_child(previous_scene)
	get_tree().root.add_child(fight_scene)
	get_tree().set_current_scene(fight_scene)
	PlayerState.inputLock = 1
	change_finish.emit()
	animator.play_backwards("fade_in")
	await(animator.animation_finished)
	self.hide()
	self.set_layer(-1)

func change_back_scene():
	self.show()
	self.set_layer(999)
	animator.play("fade_in")
	await(animator.animation_finished)
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(previous_scene)
	get_tree().set_current_scene(previous_scene)
	PlayerState.inputLock = 1
	change_finish.emit()
	animator.play_backwards("fade_in")
	await(animator.animation_finished)
	self.hide()
	self.set_layer(-1)
