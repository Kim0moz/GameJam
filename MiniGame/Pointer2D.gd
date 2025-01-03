extends Sprite2D
class_name Pointer2D

var target : Node2D
@export var targetOffset : Vector2 = Vector2(0, 4)
@export var drone : Drone
@export var camera : Camera2D
@export var cameraBorderPath : PathFollow2D
@export var dropOffGen : DropOffGenerator

enum PointerState {ON_SCREEN, OFF_SCREEN, INACTIVE}
var pointerState : PointerState = PointerState.INACTIVE
var touchingDeliveryInfo = false

func _ready():
	setState()

func _process(delta):
	setState()
	match pointerState:
		PointerState.ON_SCREEN:
			pointOnScreen()
		PointerState.OFF_SCREEN:
			pointOffScreen(delta)
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
		var deliveryTarget = (target as DeliveryTarget)
		if deliveryTarget:
			pointerState = PointerState.ON_SCREEN if deliveryTarget.onScreen else PointerState.OFF_SCREEN
			modulate.a = 1
			

func pointOffScreen(delta):
	var diffVec = target.global_position - drone.global_position
	diffVec.y *= -1
	var viewportAngle = get_viewport_rect().size.angle()
	var angle = rad_to_deg(diffVec.angle() + viewportAngle)
	if angle < 0:
		angle += 360
	rotation_degrees = floor(angle/90) * 90 - 90
	flip_v = rotation_degrees == 0 or rotation_degrees == 180
	cameraBorderPath.progress_ratio = angle / (360)
	touchingDeliveryInfo = cameraBorderPath.progress_ratio > .37 and cameraBorderPath.progress_ratio < .51
	position = cameraBorderPath.position

func pointOnScreen():
	position = target.global_position + targetOffset
	rotation_degrees = 0
	flip_v = false
	touchingDeliveryInfo = false
