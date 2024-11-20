extends Node

@export_group("References")
@export var deliveryInfo : DeliveryInfo
@export var drone : Drone
@export var capsule : Capsule2D 
@export var pointer : Pointer2D
@export var dropOffGenerator : DropOffGenerator
@onready var capsuleSpawnPoints

@export_category("Delivery Settings")
## Capsule spawn time after a delivery in seconds
@export var capsuleSpawnTime : float = 2
## Capsule delivery target time in minutes
@export var capsuleDeliveryTargetTime : float = 2
var capsuleSpawnDT : float = 0
var capsuleCarryDT : float = 0

var computerState : ComputerState = ComputerState.MINIGAME
var deliveryState : DeliveryState = DeliveryState.SPAWNING
enum ComputerState {MAIN_MENU, MINIGAME}
enum DeliveryState {SPAWNING, PICKING_UP, DELIVERING}

# Called when the node enters the scene tree for the first time.
func _ready():
	capsuleSpawnPoints = get_tree().get_nodes_in_group("CapsuleSpawnPoints")
	drone.connect("package_acquired", Callable(self, "capsulePickedUp"))
	drone.connect("package_delivered", Callable(self, "capsuleDelivered"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match computerState:
		ComputerState.MAIN_MENU:
			pass
		ComputerState.MINIGAME:
			updateMinigame(delta)
				
func updateMinigame(delta):
	match deliveryState:
		DeliveryState.SPAWNING:
			capsuleSpawnDT += delta
			if capsuleSpawnDT >= capsuleSpawnTime:
				spawnCapsule()
		DeliveryState.PICKING_UP:
			pass

func spawnCapsule():
	capsule.spawnRandomly()
	pointer.target = capsule
	drone.setStateNoPackage()
	deliveryState = DeliveryState.PICKING_UP
	deliveryInfo.TileSelected = DeliveryInfo.DeliveryState.CAPSULE_PICKUP

func capsulePickedUp():
	deliveryState = DeliveryState.DELIVERING
	pointer.target = dropOffGenerator.generateDropOffPoint()
	deliveryInfo.TileSelected = DeliveryInfo.DeliveryState.GOOD

func capsuleDelivered():
	deliveryState = DeliveryState.SPAWNING
	pointer.target.queue_free()
	capsuleSpawnDT = 0