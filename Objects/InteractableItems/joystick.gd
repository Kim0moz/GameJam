extends AnalogueItem

@export var animTree : AnimationTree



# Called when the node enters the scene tree for the first time.
func _ready():
	InputVector = Vector2.ZERO
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func activate(mousePos = Vector2.ZERO):
	InputVector = Input.get_last_mouse_velocity().normalized()
	print(InputVector)
	animTree["parameters/Axes/blend_position"] = InputVector
