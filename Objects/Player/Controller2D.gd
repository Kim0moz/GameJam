extends CharacterBody2D
class_name Controller2D


@export var speed = 100.0
var rotationGoal : float
@export var ActiveControls : bool = false

func _ready():
	$"AnimatedSprite2D".autoplay = "Idle"

func _physics_process(delta):
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction :Vector2
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	# print(rotation_degrees)
	if direction:
		direction.normalized()
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
