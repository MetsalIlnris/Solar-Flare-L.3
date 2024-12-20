extends Panel

@onready var emoLabel = $emoLabel
@onready var sanLabel = $sanLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	$emoLabel.hide()
	$sanLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hover_button_mouse_entered():
	emoLabel.set_text(str("情绪： " , PlayerState.get_lead_emo()))
	sanLabel.set_text(str("理智： " , PlayerState.get_lead_san()))
	emoLabel.show()
	sanLabel.show()

func _on_hover_button_mouse_exited():
	emoLabel.hide()
	sanLabel.hide()
