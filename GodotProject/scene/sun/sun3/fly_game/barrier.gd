extends RigidBody2D

@onready var sprite = $Sprite

var id
var radius
var speed = 50
var rotate_speed = 10
var heal:bool = false

signal hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if id == 0:
		linear_velocity.x = -120
		rotation = 0

func init(num:int):
	id = num
	var img_path:String
	$CollisionShape2D.shape = CircleShape2D.new()
	$CollisionShape2D.shape.radius = 25
	$CollisionShape2D.rotation = -10
	match id:
		1:
			# rock
			img_path = "res://asset/scene/sun3/research/fly/rock.png"
			mass = 20
			$CollisionShape2D.shape.radius = 60
			speed *= 0.6
			
		2:
			#glove
			img_path = "res://asset/scene/sun3/research/fly/glove.png"
			mass = 10
		3:
			#star
			img_path = "res://asset/scene/sun3/research/fly/star.png"
			mass = 20
		-1:
			#string
			img_path = "res://asset/scene/sun3/research/fly/string.png"
			mass = 20
			rotate_speed = 0
			rotation = 0
			$CollisionShape2D.shape = RectangleShape2D.new()
			$CollisionShape2D.shape.size = Vector2(500,50)
			speed *= 0.5
		0:
			#plane
			img_path = "res://asset/scene/sun3/research/fly/plane.png"
			mass = 2000
			rotate_speed = 0
			#freeze = true
			$CollisionShape2D.shape = RectangleShape2D.new()
			$CollisionShape2D.shape.size = Vector2(450,180)
			$CollisionShape2D.rotation = -10
			speed *= 0.4
			physics_material_override.bounce = 0
		4:
			#cookie
			img_path = "res://asset/character/sun/washer/rubbish/16180cookie.png"
			mass = 5
			heal = true
		5:
			#banana
			img_path = "res://asset/character/sun/washer/rubbish/banana.png"
			mass = 5
		6:
			#cola
			img_path = "res://asset/character/sun/washer/rubbish/cola.png"
			mass = 5
		7:
			#apple
			img_path = "res://asset/character/sun/washer/rubbish/littleapple.png"
			mass = 5
			heal = true
	var texture = ImageTexture.create_from_image(Image.load_from_file(img_path))
	sprite.texture = texture
	linear_velocity.x = -speed
	angular_velocity = rotate_speed
	if heal == true:
		remove_from_group("barrier")
