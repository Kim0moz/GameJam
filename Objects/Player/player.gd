extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export_group("References")
@export var camera : NavigationCamera
@export var cameraController : Node3D
@export var cameraTarget : Node3D

@export_category("Camera Controls")
## Offset the y position of camera to match player's perceived height.
@export var cameraOffsetY : float = .5
## Max difference allowed when reading in change in mouse x/y movement.
@export var mouseMoveMaxSpeed : float = 10
## Scaler for mouse sensitivity.
@export var mouseSensitivity : float = .5
## Control how far up/down a player can look.
@export var cameraVertRotationLimit : float = 60
@export_category("Computer State")
## Player's positional offset when in COMPUTER state
@export var computerPosOffset : Vector3 = Vector3(0, -.5, .75)
## Player's viewing angle towards the computer monitor
@export var computerAngleOffset : float = -2.5

enum PlayerState {NORMAL, COMPUTER}
var playerState : PlayerState = PlayerState.NORMAL

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	match playerState:
		PlayerState.NORMAL:
			movement(delta)

func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("movement_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("movement_left", "movement_right", "movement_forward", "movement_backward")
	input_dir.rotated(rotation.y)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	cameraController.position = position
	cameraController.position.y += cameraOffsetY
	cameraController.rotation.y = rotation.y


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouseMoveEvent : InputEventMouseMotion = event
		mouseCameraControl(mouseMoveEvent)

func mouseCameraControl(mouseMoveEvent : InputEventMouseMotion):
		if playerState != PlayerState.NORMAL:
			return
		var mouseMoveX = mouseMoveEvent.relative.x
		if mouseMoveX > 0:
			mouseMoveX = min(mouseMoveX, mouseMoveMaxSpeed)
		elif mouseMoveX < 0:
			mouseMoveX = max(mouseMoveX, -mouseMoveMaxSpeed)

		rotate_y(deg_to_rad(-mouseMoveX * mouseSensitivity))

		var mouseMoveY = mouseMoveEvent.relative.y
		if mouseMoveY > 0:
			mouseMoveY = min(mouseMoveY, mouseMoveMaxSpeed)
		elif mouseMoveX < 0:
			mouseMoveY = max(mouseMoveY, -mouseMoveMaxSpeed)
			
		cameraTarget.rotate_x(deg_to_rad(-mouseMoveY * mouseSensitivity))
		var radCamVertLimit = deg_to_rad(cameraVertRotationLimit)
		cameraTarget.rotation.x = clamp(cameraTarget.rotation.x, -radCamVertLimit, radCamVertLimit)
	

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()

func setComputerState(monitorPosition : Vector3):
	playerState = PlayerState.COMPUTER
	global_position = monitorPosition + computerPosOffset
	cameraController.position = position
	rotation.y = 0
	cameraController.rotation.y = rotation.y
	cameraTarget.rotation.x = deg_to_rad(computerAngleOffset)
	camera.Reticle.hide()
	# set_physics_process(false)