extends Node

@onready var bgmStream = $BgmStream
@onready var bgm_bus = AudioServer.get_bus_index("BGM")
@onready var lerp_timer = $LerpTimer


var cur_bgm:String =""

var target_cutoff_hz = 20000
var cur_cutoff_hz = 20000

func _process(delta):
	if target_cutoff_hz!=cur_cutoff_hz:
		# 获取音频总线上的效果器
		var effect = AudioServer.get_bus_effect(bgm_bus, 0)
		#var eq_effect = effect as AudioEffectFilter
		effect.set_cutoff(lerp(target_cutoff_hz,cur_cutoff_hz,lerp_timer.time_left/lerp_timer.wait_time))

func play_bgm(name:String):
	if name:
		if name != cur_bgm:
			bgmStream.set_stream(load(str("res://asset/audio/bgm/",name,".wav")))
			bgmStream.play()
			cur_bgm = name
	else:
		bgmStream.stop()

func enter_room_effect():
	lerp_timer.start(3)
	target_cutoff_hz = 800

func out_room_effect():
	lerp_timer.start(3)
	target_cutoff_hz = 20000

func _on_lerp_timer_timeout():
	cur_cutoff_hz = target_cutoff_hz
