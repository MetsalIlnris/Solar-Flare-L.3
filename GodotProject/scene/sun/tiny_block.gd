extends Control

@onready var timer = $Timer

var activated:bool = false
var id:int
signal pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.r = 0.5
	modulate.g = 0.5
	modulate.b = 0.5
	modulate.a = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mouse_entered() -> void:
	modulate.a = 0.8



func _on_button_mouse_exited() -> void:
	modulate.a = 1

func activate():
	activated = true
	modulate.r = 1
	modulate.g = 1
	modulate.b = 1

func inactivate():
	activated = false
	modulate.r = 0.5
	modulate.g = 0.5
	modulate.b = 0.5

func blink_error():
	$Error.show()
	for i in range(3):
		modulate.a = 0
		timer.start(0.3)
		await(timer.timeout)
		modulate.a = 1
		timer.start(0.3)
		await(timer.timeout)
	$Error.hide()

func _on_button_pressed() -> void:
	if activated:
		inactivate()
	else:
		activate()
	pressed.emit(id)
