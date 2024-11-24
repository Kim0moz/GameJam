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
@export var capsuleDeliveryTargetTime : float = 1
var capsuleSpawnDT : float = 0
var capsuleDeliveryDT : float = 0

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
		DeliveryState.DELIVERING:
			updateDeliveryStatus(delta)

func updateDeliveryStatus(delta):
	capsuleDeliveryDT += delta
	var deliveryTargetTimeSeconds = capsuleDeliveryTargetTime * 60
	var deliveryTargetTimeQuarter = deliveryTargetTimeSeconds / 4
	if capsuleDeliveryDT / deliveryTargetTimeQuarter <= 4:
		deliveryInfo.TileSelected = (DeliveryInfo.DeliveryStatus.GOOD + int(capsuleDeliveryDT/deliveryTargetTimeQuarter)) as DeliveryInfo.DeliveryStatus
	var timeRemaining = deliveryTargetTimeSeconds - capsuleDeliveryDT
	var seconds = floor(timeRemaining)
	var milliseconds = (timeRemaining - floor(timeRemaining)) * 100
	var timeString = "%02d:%02d" % [seconds, milliseconds]
	deliveryInfo.TimeLabel.text = timeString


func spawnCapsule():
	capsule.spawnRandomly()
	pointer.target = capsule
	drone.setStateNoPackage()
	deliveryState = DeliveryState.PICKING_UP
	deliveryInfo.TileSelected = DeliveryInfo.DeliveryStatus.CAPSULE_PICKUP
	deliveryInfo.TimeLabel.text = "00:00"
	deliveryInfo.setTextState(DeliveryInfo.TextState.STABLE)

func capsulePickedUp():
	deliveryState = DeliveryState.DELIVERING
	pointer.target = dropOffGenerator.generateDropOffPoint()
	deliveryInfo.TileSelected = DeliveryInfo.DeliveryStatus.GOOD
	capsuleDeliveryDT = 0

func capsuleDelivered():
	deliveryState = DeliveryState.SPAWNING
	pointer.target.queue_free()
	capsuleSpawnDT = 0
	deliveryInfo.setTextState(DeliveryInfo.TextState.FLASHING)