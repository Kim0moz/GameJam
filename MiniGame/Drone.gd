extends Controller2D

@export var ringParticles : CPUParticles2D
## Offset from the drone body from which particles emit
@export var ringParticlesOffset : float = -4
## How much to offset the particle angles by -- CURRENTLY DOESN'T DO ANYTHING
@export var particleAngleOffset : float = 270

func _physics_process(delta):
	super(delta)

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
