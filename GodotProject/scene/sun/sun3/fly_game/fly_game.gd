extends CanvasLayer

@onready var timer_digit = $Frame/Digit
@onready var fly_c = $Control/FlyCharacter

var countdown_time = 60
var cur_timer:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_digit.generate(countdown_time)
	cur_timer = countdown_time
	fly_c.hp_changed.connect(_on_hp_changed)
	fly_c.gameover.connect(gameover)
	var tween = get_tree().create_tween()
	$Over/Ready.show()
	$Over/Ready.scale = Vector2(1.5,1.5)
	tween.tween_property($Over/Ready, "scale",Vector2(1,1), 0.5)
	tween.set_ease(Tween.EASE_OUT)
	await(get_tree().create_timer(1.5).timeout)
	$Over/Ready.hide()
	$Over/Go.show()
	$Over/Go.scale = Vector2(1.3,1.3)
	#tween = get_tree().create_tween()
	#tween.tween_property($Over/Go, "scale",Vector2(1,1), 0.5)
	await(get_tree().create_timer(1).timeout)
	$Over/Go.hide()
	fly_c.start()
	$Frame/Digit/Timer.start(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	cur_timer -= 1
	if cur_timer <= 0:
		cur_timer = 0
		# 倒计时结束
		gameover()
	timer_digit.generate(int(cur_timer))

func _on_hp_changed():
	$Frame/Bunny/Control.size.y = fly_c.one_hp * 260/4
	$Frame/Bunny/Control.position.y = -129 + (4-fly_c.one_hp) * 260/4
	$Frame/Bunny/Control/Light.position.y = 130 + (fly_c.one_hp-4)* 260/4
	$Frame/Apple/Control.size.y = fly_c.app_hp * 260/4
	$Frame/Apple/Control.position.y = -129 + (4-fly_c.app_hp) * 260/4
	$Frame/Apple/Control/Light.position.y = 130 + (fly_c.app_hp-4)* 260/4

func gameover():
	$Frame/Digit/Timer.stop()
	fly_c.on_gameover()
	$Over/Win.show()
	$Over/Win2.show()
	if fly_c.app_hp < fly_c.one_hp:
		$Over/Win.play("win")
		$Over/Win2.play("lose")
	else:
		$Over/Win.play("lose")
		$Over/Win2.play("win")
	
	
