extends CanvasLayer

@onready var timer = $Timer
@onready var grid = $GridContainer
@onready var mouse_blocker = $MouseBlocker

var grid_code:Array = []
var display_speed = 1
var refreshing = false
var cur_block = 0 # 记录玩家下一个应该点按的block

signal gameover

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_back_button_button_up()
	_on_reset_button_button_up()
	grid_code = []
	for i in range(36):
		grid_code.append(randi_range(0,1))
		grid.get_child(i).inactivate()
		grid.get_child(i).pressed.connect(on_block_pressed)
		grid.get_child(i).id = i

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_game(code):
	if self.visible == false:
		show()
		grid_code = code
		cur_block = -1 
		set_next_block()
		refreshing = true
		display_grid_code()
		PlayerState.ban_input()

func display_grid_code():
	mouse_blocker.show()
	if grid_code.size() < 36:
		return
	await(blink_line())
	await(blink_all())
	refreshing = false
	for i in range(36):
		if refreshing:
			return
		if grid_code[i] == 1:
			$GridContainer.get_child(i).activate()
			timer.start(0.5)
			await(timer.timeout)
			$GridContainer.get_child(i).inactivate()
	mouse_blocker.hide()

func blink_line():
	for i in range(6):
		activate_line(i)
		timer.start(0.1)
		await(timer.timeout)
		inactivate_line(i)
	for i in range(6):
		activate_line(i)
		timer.start(0.1)
		await(timer.timeout)
		inactivate_line(i)
	timer.start(0.2)
	await(timer.timeout)

func blink_all():
	for i in range(6):
		activate_line(i)
	timer.start(0.1)
	await(timer.timeout)
	for i in range(6):
		inactivate_line(i)
	timer.start(0.1)
	await(timer.timeout)
	for i in range(6):
		activate_line(i)
	timer.start(0.5)
	await(timer.timeout)
	for i in range(6):
		inactivate_line(i)
	timer.start(0.5)
	await(timer.timeout)

func activate_line(n:int):
	for i in range((n-1)*6,n*6):
		grid.get_child(i).activate()

func inactivate_line(n:int):
	for i in range((n-1)*6,n*6):
		grid.get_child(i).inactivate()

func on_block_pressed(id):
	if id == cur_block:
		set_next_block()
	else:
		mouse_blocker.show()
		refreshing = true
		await(grid.get_child(id).blink_error())
		await(blink_line())
		refreshing = false

func set_next_block():
	for i in range(cur_block+1,36):
		if grid_code[i] == 1:
			cur_block = i
			return
	on_success()

func on_success():
	PlayerState.allow_input()
	PlayerState.activater_result.emit(1)
	gameover.emit(true)
	hide()

func _on_back_button_button_down() -> void:
	$BackButton/BackOn.hide()
	$BackButton/ShadowOff.position = Vector2(82,98)
	$BackButton/ShadowOff.scale = Vector2(0.95,0.95)


func _on_back_button_button_up() -> void:
	$BackButton/BackOn.show()
	$BackButton/ShadowOff.position = Vector2(74,110)
	$BackButton/ShadowOff.scale = Vector2(0.98,0.98)


func _on_reset_button_button_down() -> void:
	$ResetButton/ResetOn.hide()
	$ResetButton/ShadowOff.position = Vector2(82,98)
	$ResetButton/ShadowOff.scale = Vector2(0.95,0.95)


func _on_reset_button_button_up() -> void:
	$ResetButton/ResetOn.show()
	$ResetButton/ShadowOff.position = Vector2(74,110)
	$ResetButton/ShadowOff.scale = Vector2(0.98,0.98)


func _on_reset_button_pressed() -> void:
	if refreshing == true:
		return
	refreshing = true
	cur_block = -1 
	set_next_block()
	display_grid_code()


func _on_back_button_pressed() -> void:
	PlayerState.allow_input()
	PlayerState.activater_result.emit(0)
	gameover.emit(false)
	hide()
