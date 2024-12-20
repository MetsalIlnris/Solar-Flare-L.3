class_name CheckButton
extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	$Sprite2D.show()


func _on_mouse_exited():
	$Sprite2D.hide()


func _on_button_up():
	self.queue_free()
