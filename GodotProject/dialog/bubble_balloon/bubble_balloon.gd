extends CanvasLayer

@onready var balloon: Panel = %Balloon
@onready var dialogue_frame = $Balloon/Dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu
@onready var expression = $Balloon/Expression
@onready var animation_player = $AnimationPlayer

var have_expression:bool = false
var direction = 0

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

var expression_list:Array = ["yanFail","yanSuccess","16180Success","16180Fail"]

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			animation_player.play("fold_close")
			responses_menu.hide()
			dialogue_frame.hide()
			await(animation_player.animation_finished)
			queue_free()
			return

		dialogue_line = next_dialogue_line

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show expression and adjust the position of ballon
		have_expression = false#当作flag
		if dialogue_line.tags.size() == 0:
			dialogue_frame.position.x = 0
			dialogue_frame.size.x = 1340
			expression.play("default")
		for tag in dialogue_line.tags:
			if tag == "l":
				pass
			elif tag == "r":
				pass
			elif tag in expression_list:
				expression.play(tag)
				have_expression = true
		if have_expression == false:
			expression.play("default")

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait a time
		var time
		if dialogue_line.time != "":
			time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		else:
			time = dialogue_line.text.length() * 0.02 + 2
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)

	get:
		return dialogue_line


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	animation_player.play("fold_open")
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	pass


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
