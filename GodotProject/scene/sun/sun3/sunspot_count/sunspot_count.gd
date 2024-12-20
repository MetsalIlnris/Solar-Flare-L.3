extends CanvasLayer

@onready var spots = $SpotCanvas/Spots
@onready var timer_digit = $Len/Timer
@onready var count_digit = $Len/Count

var collected_cnt = 0
var countdown_time = 60
var cur_timer:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_digit.generate(countdown_time)
	count_digit.generate(0)
	cur_timer = countdown_time
	var node
	var cnt = 0
	for i in range(randi_range(5,15),randi_range(40,50)):
		cnt += 1
		node = load("res://scene/sun/sun3/sunspot_count/sun_spot.tscn").instantiate()
		node.generate(randi_range(1,4),randf_range(0.2,0.8))
		node.spot_pressed.connect(_on_spot_pressed)
		spots.add_child(node)
		var rng = RandomNumberGenerator.new()
		#取正态分布随机数，再旋转随机角度
		node.position.x = randfn(300 + i*15,150)
		if node.position.x > 1550 or node.position.x < 0:
			node.position.x = randi_range(0,1550)
		#顺时针旋转生成，逐渐向外，避免相聚太近
		node.position = node.position.rotated(randf_range(i/5+0,i/5+PI/6))
	var random_angles = []
	var exist_close_angle
	# 生成6个随机角度
	while random_angles.size() < 6:
		exist_close_angle = false
		var new_angle = randf_range(0, 2.0 * PI)
		for angle in random_angles:
			if abs(angle-new_angle) < PI / 6:
				exist_close_angle = true
				break
		if exist_close_angle:
			continue
		else:
			random_angles.append(new_angle)
			random_angles.sort()
	# 每个器官都会出现
	for n in range(6):
		if n == 2 or n == 3:
			#78号hand特殊处理
			continue
		node = load("res://scene/sun/sun3/sunspot_count/sun_spot.tscn").instantiate()
		spots.add_child(node)
		node.generate(n + 5,randf_range(0.4,0.8))
		node.position.x = randfn(1100,100)
		node.position = node.position.rotated(random_angles[n])
	# 一个四周布满手的小彩蛋
	if randi_range(0,5) == 0:    
		for n in range(60): 
			node = load("res://scene/sun/sun3/sunspot_count/sun_spot.tscn").instantiate()
			spots.add_child(node)
			node.generate(7,0.6)
			node.position.x = 1720
			node.position = node.position.rotated(n*PI / 25)
			node.rotation = PI/2 + n*PI/25
	elif randi_range(0,2) == 0:
		for n in range(60): 
			node = load("res://scene/sun/sun3/sunspot_count/sun_spot.tscn").instantiate()
			spots.add_child(node)
			node.generate(8,0.5)
			node.position.x = 1700
			node.position = node.position.rotated(n*PI / 25)
			node.rotation = PI/2 + n*PI/25
	else:
		node = load("res://scene/sun/sun3/sunspot_count/sun_spot.tscn").instantiate()
		spots.add_child(node)
		node.generate(7,0.6)
		node.position.x = 1720
		node.position = node.position.rotated(random_angles[2])
		node.rotation = PI/2 + random_angles[2]
		node = load("res://scene/sun/sun3/sunspot_count/sun_spot.tscn").instantiate()
		spots.add_child(node)
		node.generate(8,0.5)
		node.position.x = 1700
		node.position = node.position.rotated(random_angles[3])
		node.rotation = PI/2 + random_angles[3]

func _on_spot_pressed():
	collected_cnt += 1
	count_digit.generate(collected_cnt)
	$Len/AnimationPlayer.play("add_num")


func _on_timer_timeout() -> void:
	cur_timer -= 1
	if cur_timer <= 0:
		cur_timer = 0
		# 倒计时结束
	timer_digit.generate(int(cur_timer))
