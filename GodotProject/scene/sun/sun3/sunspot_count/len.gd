extends Camera2D

@onready var inner_knob = $InnerKnob

var mouse_start_pos : Vector2
var mouse_holding : bool
var len_limit = 1600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bit_map = BitMap.new()
	bit_map.create_from_image_alpha(inner_knob.texture_normal.get_image())
	inner_knob.set_click_mask(bit_map)
	inner_knob.pivot_offset = inner_knob.size/2
	$ControllComponent.limit_h = Vector2(-len_limit,len_limit)
	$ControllComponent.limit_v = Vector2(-len_limit,len_limit)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_holding == true:
		var rotate = mouse_start_pos.angle_to(get_global_mouse_position()-global_position)
		#inner_knob.rotation = clamp(inner_rotation + rotate,- PI,PI)
		if inner_knob.rotation + rotate < 0:
			inner_knob.rotation = 0
		elif inner_knob.rotation + rotate > 2*PI:
			inner_knob.rotation = 2*PI
		else:
			inner_knob.rotation += rotate
		var ratio = lerp(1.0,0.6,inner_knob.rotation / (2*PI))
		$"../SpotCanvas".scale = Vector2(ratio,ratio)
		$ControllComponent.limit_h = Vector2(-len_limit,len_limit) * (1- (1 - ratio) * 1.5)
		$ControllComponent.limit_v = Vector2(-len_limit,len_limit) * (1- (1 - ratio) * 1.5)
		mouse_start_pos = get_global_mouse_position() - global_position
		


func _on_inner_knob_button_down() -> void:
	mouse_holding = true
	mouse_start_pos = get_global_mouse_position() - global_position


func _on_inner_knob_button_up() -> void:
	mouse_holding = false
