extends CanvasLayer

@onready var b1 = $Button1
@onready var b2 = $Button2
@onready var b3 = $Button3
@onready var b4 = $Button4
@onready var b5 = $Button5
@onready var bb = $ButtonB

var b_state = [false,false,false,false,false,false]
var light_state = [false,false,false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display():
	if self.visible == false:
		PlayerState.ban_input()
		show()

func refresh():
	b_state[0] = bb.state
	b_state[1] = b1.state
	b_state[2] = b2.state
	b_state[3] = b3.state
	b_state[4] = b4.state
	b_state[5] = b5.state
	if b_state[1] == true and b_state[2] == true and b_state[3] == true and b_state[4] == false and b_state[5] == false:
		if light_state[0] == false:
			PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light1_on")
		light_state[0] = true
		$Light1/Lighton.show()
	else:
		light_state[0] = false
		$Light1/Lighton.hide()
	if b_state[2] == true and b_state[3] == true and b_state[4] == true and b_state[1] == false and b_state[5] == false:
		if light_state[1] == false:
			PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light2_on")
		light_state[1] = true
		$Light2/Lighton.show()
	else:
		light_state[1] = false
		$Light2/Lighton.hide()
	if b_state[3] == true and b_state[4] == true and b_state[5] == true and b_state[1] == false and b_state[2] == false:
		if light_state[2] == false:
			PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light3_on")
		light_state[2] = true
		$Light3/Lighton.show()
	else:
		light_state[2] = false
		$Light3/Lighton.hide()

func _on_button_1_pressed() -> void:
	b2.turn_off()
	refresh()


func _on_button_2_pressed() -> void:
	b1.turn_off()
	b3.turn_off()
	refresh()


func _on_button_3_pressed() -> void:
	b2.turn_off()
	b4.turn_off()
	refresh()


func _on_button_4_pressed() -> void:
	b3.turn_off()
	b5.turn_off()
	refresh()


func _on_button_5_pressed() -> void:
	b4.turn_off()
	refresh()


func _on_button_b_pressed() -> void:
	b1.switch()
	b2.switch()
	b3.switch()
	b4.switch()
	b5.switch()
	refresh()


func _on_back_pressed() -> void:
	PlayerState.allow_input()
	hide()


func _on_light_button_1_pressed() -> void:
	if light_state[0] == true:
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light1_on")
	else:
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light1_off")


func _on_light_button_2_pressed() -> void:
	if light_state[1] == true:
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light2_on")
	else:
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light2_off")


func _on_light_button_3_pressed() -> void:
	if light_state[2] == true:
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light3_on")
	else:
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","switch_light3_off")
