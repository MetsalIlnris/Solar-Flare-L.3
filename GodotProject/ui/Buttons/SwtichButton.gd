class_name SwitchButton
extends Control

@onready var anim = $AnimatedSprite2D

var state:bool = false
signal pressed
signal switched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turn_off()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	switch()
	pressed.emit()

func switch():
	state = !state
	if state == true:
		turn_on()
	else:
		turn_off()
	switched.emit()

func turn_on():
	state = true
	anim.play("on")

func turn_off():
	state = false
	anim.play("off")

		
