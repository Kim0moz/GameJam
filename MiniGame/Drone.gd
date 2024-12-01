extends Controller2D
class_name Drone

@export_group("Particles")
@export var ringParticles : CPUParticles2D
## Offset from the drone body from which particles emit
@export var ringParticlesOffset : float = -4
## How much to offset the particle angles by -- CURRENTLY DOESN'T DO ANYTHING
@export var particleAngleOffset : float = 270
@export_group("Package Delivery")
## How much the package is offset from the drone when being delivered
@export var packageFollowOffset : Vector2 = Vector2(0, 6)
## Lower value makes package move more slowly while following drone
@export var packageFollowSmoothing : float = .5
## Max distance package can drift from drone
@export var maxPackageDist : float = 20
@export var pointer : Pointer2D
@export var damageTime := 1.5
var originalSpeed
var damageDT = 0
var package

signal package_acquired
signal package_delivered
signal damage_taken

enum DroneState {NO_PACKAGE, DELIVERING, NO_CONTROLS, DAMAGED}
var droneState : DroneState = DroneState.NO_CONTROLS

func _ready():
	super()
	originalSpeed = speed

func _physics_process(delta):
	if droneState == DroneState.NO_CONTROLS:
		return
	super(delta)
	movement()
	match droneState:
		DroneState.NO_PACKAGE:
			pass
		DroneState.DELIVERING:
			updatePackagePosition()
		DroneState.DAMAGED:
			updateDamage(delta)

var prevVel
func updatePackagePosition():
	if velocity.length() != 0:
		prevVel = velocity
	var packagePos : Vector2
	var packageOffset = packageFollowOffset.rotated(prevVel.angle())
	packagePos.x = move_toward(package.position.x, position.x + packageOffset.x, packageFollowSmoothing)
	packagePos.y = move_toward(package.position.y, position.y + packageOffset.y, packageFollowSmoothing)
	if (position-packagePos).length() > maxPackageDist:
		packagePos = position + (packagePos-position).normalized() * maxPackageDist
	package.position = packagePos
	

func movement():
	if velocity.length() != 0:
		ringParticles.emitting = true
		var normVel = velocity.normalized()
		ringParticles.direction = normVel * -1
		ringParticles.position = normVel * ringParticlesOffset
		# var particleAngle = rad_to_deg(atan2(velocity.y, velocity.x)) + particleAngleOffset
		var particleAngle : float
		if normVel.y > 0:
			particleAngle = 180
		elif normVel.y < 0:
			particleAngle = 0
		elif normVel.x > 0:
			particleAngle = 270
		elif normVel.x < 0:
			particleAngle = 90
		
		ringParticles.angle_max = particleAngle
		ringParticles.angle_min = particleAngle
	else:
		ringParticles.emitting = false

func setStateDelivering(package):
	if droneState == DroneState.DELIVERING:
		return
	droneState = DroneState.DELIVERING
	package_acquired.emit()
	self.package = package

func setStateNoPackage():
	droneState = DroneState.NO_PACKAGE
	package = null

func packageDelivered():
	setStateNoPackage()
	package_delivered.emit()

func takeDamage():
	if droneState == DroneState.DAMAGED or droneState == DroneState.NO_CONTROLS:
		return
	
	droneState = DroneState.DAMAGED
	damage_taken.emit()
	speed = originalSpeed * .5
	damageDT = 0

func updateDamage(delta):
	damageDT += delta
	modulate.a = 0 if (int(damageDT * 10) % 6 < 3) else 1
	if damageDT >= damageTime:
		resetDrone()
		droneState = DroneState.NO_PACKAGE

func resetDrone():
	modulate.a = 1
	speed = originalSpeed