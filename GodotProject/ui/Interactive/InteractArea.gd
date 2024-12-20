extends Area2D

@export var dialog:bool = true
@export var scene:String
@export var label:String
@export var tip:String
@export var interact_mode:interact_enum = interact_enum.active
@export var one_shot:bool = false
@export var scene_func:bool
@export var parent_func:bool = false
@export var label_height = -220

@onready var tip_label = $CollisionShape2D/TipLabel
@onready var anim = $AnimationPlayer

enum interact_enum{
	active,
	passive
}

func _ready():
	tip_label.hide()
	tip_label.set_text(tip)
	tip_label.set_z_index(50)
	tip_label.position =  Vector2(-130,label_height +40)
	tip_label.modulate = Color(1,1,1,0)

func on_interact_button_pressed():
	if(interact_mode == interact_enum.active):
		interact()

func interact():
	if dialog and scene and label:
		PlayerState.show_main_dialogue_balloon("world_dialog/"+scene,label)
	if scene_func and scene and label:
		get_tree().current_scene.call(str(scene,'_',label))
	if parent_func and scene and label:
		get_parent().call(str(scene,'_',label))
	if one_shot:
		queue_free()


func _on_body_entered(body):
	if(body == PlayerState.cur_interact_body):
		PlayerState.set_interact_area(self)
		if(interact_mode == interact_enum.passive):
			interact()


func _on_body_exited(body):
	if(body == PlayerState.cur_interact_body):
		PlayerState.exit_interact_area(self)

func show_tip():
	tip_label.show()
	tip_label.set_text(tip)
	var tween = get_tree().create_tween()
	tween.tween_property(tip_label,"position",Vector2(-130,label_height),0.4)
	tween.parallel().tween_property(tip_label,"modulate",Color(1,1,1,1),0.4)

func hide_tip():
	var tween = get_tree().create_tween()
	tween.tween_property(tip_label,"position",Vector2(-130,label_height +40),0.4)
	tween.parallel().tween_property(tip_label,"modulate",Color(1,1,1,0),0.4)
