extends Area2D
class_name Capsule2D

var onScreen = false
var drone : Drone

var capsuleState : CapsuleState = CapsuleState.IDLE
enum CapsuleState {IDLE, SPAWNED}

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0

func onBodyEntered(body):
	if body.name == "Drone" and capsuleState == CapsuleState.SPAWNED:
		(body as Drone).setStateDelivering(self)
		drone = body
		
func onAreaEntered(area):
	if area.name.contains("DeliveryTarget") and capsuleState == CapsuleState.SPAWNED:
		modulate.a = 0
		capsuleState = CapsuleState.IDLE
		drone.packageDelivered()

func spawnRandomly():
	position = get_tree().get_nodes_in_group("CapsuleSpawnPoints").pick_random().position
	modulate.a = 1
	capsuleState = CapsuleState.SPAWNED


func screenEntered():
	onScreen = true

func screenExited():
	onScreen = false