extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export_group("References")
@export var camera : NavigationCamera
@export var cameraController : Node3D
@export var cameraTarget : Node3D

@export_group("Camera Controls")
## Offset the y position of camera to match player's perceived height.
@export var cameraOffsetY : float = .5
## Max difference allowed when reading in change in mouse x/y movement.
@export var mouseMoveMaxSpeed : float = 10
## Scaler for mouse sensitivity.
@export var mouseSensitivity : float = .5
## Control how far up/down a player can look.
@export var cameraVertRotationLimit : float = 60
@export_group("Computer State")
## Player's positional offset when in COMPUTER state
@export var computerPosOffset : Vector3 = Vector3(0, -.5, .75)
## Player's viewing angle towards the computer monitor
@export var computerAngleOffset : float = -2.5
## Player's positional offset when exiting COMPUTER state
@export var computerExitPosOffset : Vector3 = Vector3(0, .5, -1)
## Length of computer tween animation
@export var computerTransTweenLen = .5

signal computer_exit

enum PlayerState {NORMAL, COMPUTER, TRANSITION}
var playerState : PlayerState = PlayerState.NORMAL

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	match playerState:
		PlayerState.NORMAL:
			movement(delta)
		PlayerState.COMPUTER:
			camera.Reticle.global_position = camera.Reticle.get_global_mouse_position()

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
	if event.is_action_pressed("exit_computer"):
		if playerState != PlayerState.COMPUTER:
			return
		exitComputerTransition()

func startComputerState(monitorPosition : Vector3):
	playerState = PlayerState.TRANSITION
	var posTween = create_tween()
	posTween.tween_property(self, "global_position", monitorPosition + computerPosOffset, computerTransTweenLen).set_trans(Tween.TRANS_SINE)
	posTween.tween_callback(Callable(self, "setPlayerState").bind(PlayerState.COMPUTER))
	var posTween2 = create_tween()
	posTween2.tween_property(cameraController, "global_position", monitorPosition + computerPosOffset, computerTransTweenLen).set_trans(Tween.TRANS_SINE)
	var rotationTween = create_tween()
	rotationTween.tween_property(self, "rotation", Vector3.ZERO, computerTransTweenLen).set_trans(Tween.TRANS_SINE)
	var rotationTween2 = create_tween()
	rotationTween2.tween_property(cameraController, "rotation", Vector3.ZERO, computerTransTweenLen).set_trans(Tween.TRANS_SINE)
	var rotationTween3 = create_tween()
	rotationTween3.tween_property(cameraTarget, "rotation", Vector3(deg_to_rad(computerAngleOffset), 0, 0), computerTransTweenLen).set_trans(Tween.TRANS_SINE)
	# camera.Reticle.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func exitComputerTransition():
	playerState = PlayerState.TRANSITION
	var posTween = create_tween()
	posTween.tween_property(self, "global_position", global_position + computerExitPosOffset, computerTransTweenLen).set_trans(Tween.TRANS_SINE)
	posTween.tween_callback(Callable(self, "computerExited"))
	var cameraPos = global_position + computerExitPosOffset
	cameraPos.y += cameraOffsetY
	var posTween2 = create_tween()
	posTween2.tween_property(cameraController, "global_position", cameraPos, computerTransTweenLen).set_trans(Tween.TRANS_SINE)

func computerExited():
	playerState = PlayerState.NORMAL
	# camera.Reticle.show()
	camera.Reticle.position = Vector2(560, 308)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	computer_exit.emit()
	
func setPlayerState(pState : PlayerState):
	playerState = pState
