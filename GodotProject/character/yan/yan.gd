extends "res://character/character.gd"

func _ready(): 
	super()
	switch_outfit(0)

func switch_outfit(index:int):
	match index:
		0:
			mainAnim.set_sprite_frames(load("res://character/yan/yan_anime.tres"))
		1:
			mainAnim.set_sprite_frames(load("res://character/yan/yan_helmet_anime.tres"))
		2:
			mainAnim.set_sprite_frames(load("res://character/yan/yan_dressed_anime.tres"))
	
