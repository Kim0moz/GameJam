extends Area2D
class_name AntiDroneShot

@export var moveSpeed := 10.0
var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(rot : float):
	global_rotation = rot
	velocity = Vector2(0, moveSpeed).rotated(rot+PI)
	z_index = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += velocity * delta

func onBodyEnter(body : Node2D):
	var drone = body as Drone
	if drone:
		print("hit drone")
	queue_free()