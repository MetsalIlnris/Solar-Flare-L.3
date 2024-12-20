extends "res://character/character.gd"

@onready var sleepAnim = $MainAnim/SleepAnim

var awake:bool = false
var activate_code = []

signal activate_start

func _ready() -> void:
	super()
	for i in range(36):
		activate_code.append(0)
	for i in range(6):
		activate_code[6*i + randi_range(0,5)] = 1

func _physics_process(delta: float) -> void:
	if awake == false:
		if not is_on_floor():
			velocity.y += gravity * delta
			move_and_slide()
		return
	if cur_state:
		cur_state.ch = self
		cur_state.physics_update(delta)
	#单独处理wait的motion
	if wait_target:
		if global_position.distance_to(wait_target.global_position) > walk_distance:
			waiting = true
		elif global_position.distance_to(wait_target.global_position) < close_distance:
			waiting = false
	if waiting:
		motion.walk = false
		motion.run = false
	if motion.walk == false and motion.run == false and awake == true:
		$MainAnim/Eye.show()
	else:
		$MainAnim/Eye.hide()
	if move == true:
		_move(delta)
	else:
		velocity = Vector2(0,0)
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func wash():
	state_transition(cur_state, "wash")

func washer_talk():
	if awake == false:
		PlayerState.show_main_dialogue_balloon("world_dialog/washer","talk_to_sleep")
		PlayerState.dialog_action.connect(activate)
	else:
		PlayerState.show_main_dialogue_balloon("world_dialog/washer","talk")

func activate(do:int):
	if do == 0:
		return 
	activate_start.emit(activate_code)
	PlayerState.activater_result.connect(do_awake)

func do_awake(do:int):
	PlayerState.activater_result.disconnect(do_awake)
	if do == 1:
		sleepAnim.play("awake")
		$InteractArea.tip = "检查"
		await get_tree().create_timer(2).timeout
		awake = true
		sleepAnim.queue_free()
		$MainAnim.self_modulate.a = 1
		$Dialog2.show()
	else:
		pass
