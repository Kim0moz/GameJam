extends Area2D
class_name Capsule2D

var onScreen = false
var drone : Drone
var willGlitch = false

var capsuleState : CapsuleState = CapsuleState.IDLE
enum CapsuleState {IDLE, SPAWNED, NO_DELIVERY}

signal glitch_delivery

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0

func onBodyEntered(body):
	if body.name == "Drone" and capsuleState == CapsuleState.SPAWNED:
		(body as Drone).setStateDelivering(self)
		drone = body
		
func onAreaEntered(area):
	var deliveryTarget = area as DeliveryTarget
	if deliveryTarget != null and capsuleState == CapsuleState.SPAWNED:
		if willGlitch:
			glitch_delivery.emit()
			willGlitch = false
		else:
			setToIdle()
			drone.packageDelivered()

func setToIdle():
	modulate.a = 0
	capsuleState = CapsuleState.IDLE

func spawnRandomly():
	# position = get_tree().get_nodes_in_group("CapsuleSpawnPoints")[0].position
	position = get_tree().get_nodes_in_group("CapsuleSpawnPoints").pick_random().position
	modulate.a = 1
	capsuleState = CapsuleState.SPAWNED


func screenEntered():
	onScreen = true

func screenExited():
	onScreen = false