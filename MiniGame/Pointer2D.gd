extends Node2D
class_name Pointer2D

var target : Node2D
@export var targetOffset : Vector2 = Vector2(0, 4)

enum PointerState {ON_SCREEN, OFF_SCREEN, INACTIVE}
var pointerState : PointerState = PointerState.INACTIVE

# Called when the node enters the scene tree for the first time.
func _ready():
	setState()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setState()
	# print(get_viewport_rect().has_point(target.position))
	# print(get_viewport_rect().size)
	match pointerState:
		PointerState.ON_SCREEN:
			pointOnScreen()
		PointerState.OFF_SCREEN:
			pointOffScreen()
		PointerState.INACTIVE:
			pass

func setState():
	if target == null:
		pointerState = PointerState.INACTIVE
		modulate.a = 0
	else:
		var capsuleTarget = (target as Capsule2D)
		if capsuleTarget:
			pointerState = PointerState.ON_SCREEN if capsuleTarget.onScreen else PointerState.OFF_SCREEN
			modulate.a = 1
			

func pointOffScreen():
	position = target.position

func pointOnScreen():
	position = target.position + targetOffset
