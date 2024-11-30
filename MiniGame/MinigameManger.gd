extends Node

@export_group("References")
@export var deliveryInfo : DeliveryInfo
@export var drone : Drone
@export var capsule : Capsule2D 
@export var pointer : Pointer2D
@export var dropOffGenerator : DropOffGenerator
@export var deliveryConfirmationText : PackedScene
@export var player : Player
@export var mainMenuScreen : Control
var capsuleSpawnPoints

@export_category("Delivery Settings")
## Capsule spawn time after a delivery in seconds
@export var capsuleSpawnTime : float = 2
## Capsule delivery target time in minutes
@export var capsuleDeliveryTargetTime : float = 1
var capsuleSpawnDT : float = 0
var capsuleDeliveryDT : float = 0

@export_category("Delivery Stats")
@export var deliveryTotal := 0
@export var deliveryPoints := 0
const RANKING_MAX = 1032
var ranking := RANKING_MAX
const MAX_DELIVERY_POINTS = 20
var nextRankPoints := 5
var ptsSinceLastRank = 0

var computerState : ComputerState = ComputerState.INACTIVE
var deliveryState : DeliveryState = DeliveryState.SPAWNING
enum ComputerState {INACTIVE, MAIN_MENU, MINIGAME}
enum DeliveryState {SPAWNING, PICKING_UP, DELIVERING}

# Called when the node enters the scene tree for the first time.
func _ready():
	capsuleSpawnPoints = get_tree().get_nodes_in_group("CapsuleSpawnPoints")
	drone.connect("package_acquired", Callable(self, "capsulePickedUp"))
	drone.connect("package_delivered", Callable(self, "capsuleDelivered"))
	if player:
		player.connect("computer_enter", Callable(self, "computerEntered"))
		player.connect("computer_exit", Callable(self, "computerExited"))
	else:
		computerState = ComputerState.MAIN_MENU

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match computerState:
		ComputerState.MAIN_MENU:
			if Input.is_action_just_pressed("enter"):
				startGame()
		ComputerState.MINIGAME:
			updateMinigame(delta)
				
func updateMinigame(delta):
	match deliveryState:
		DeliveryState.SPAWNING:
			capsuleSpawnDT += delta
			if capsuleSpawnDT >= capsuleSpawnTime:
				spawnCapsule()
		DeliveryState.PICKING_UP:
			deliveryInfo.modulate.a = .5 if pointer.touchingDeliveryInfo else 1.0
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
	deliveryInfo.modulate.a = .5 if pointer.touchingDeliveryInfo else 1.0

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
	var delivConfText = (deliveryConfirmationText.instantiate() as DeliveryConfirmationText)
	if capsuleDeliveryDT > capsuleDeliveryTargetTime * 60:
		delivConfText.setTextIndex(delivConfText.deliveryMessages.size() - 1)
	else:
		delivConfText.setTextIndex(int(deliveryInfo.TileSelected)-1)
	delivConfText.global_position = pointer.target.global_position + Vector2(-delivConfText.size.x/2, -(delivConfText.size.y + 10))
	delivConfText.z_index = 100
	add_child(delivConfText)
	pointer.target.queue_free()
	capsuleSpawnDT = 0
	deliveryInfo.setTextState(DeliveryInfo.TextState.FLASHING)
	deliveryTotal += 1
	calculateDeliveryPoints()
	mainMenuScreen.get_node("DeliveryStats/DeliveryTotalText").text = "Today's Delivery Total: %d" % deliveryTotal
	mainMenuScreen.get_node("DeliveryStats/DeliveryPointText").text = "Today's Delivery Points: %d" % deliveryPoints
	checkNextRank()

func computerEntered():
	computerState = ComputerState.MAIN_MENU
	mainMenuScreen.set_process(true)
	mainMenuScreen.visible = true

func computerExited():
	computerState = ComputerState.INACTIVE
	mainMenuScreen.set_process(true)
	mainMenuScreen.visible = true
	drone.droneState = Drone.DroneState.NO_CONTROLS
	if pointer.target != null and pointer.target != capsule:
		pointer.target.queue_free()
	else:
		pointer.target = null
	deliveryInfo.TileSelected = DeliveryInfo.DeliveryStatus.CAPSULE_PICKUP
	deliveryInfo.TimeLabel.text = "00:00"
	deliveryInfo.setTextState(DeliveryInfo.TextState.STABLE)
	capsule.capsuleState = Capsule2D.CapsuleState.IDLE
	capsule.modulate.a = 0

func startGame():
	computerState = ComputerState.MINIGAME
	mainMenuScreen.set_process(false)
	mainMenuScreen.visible = false
	drone.droneState = Drone.DroneState.NO_PACKAGE
	capsuleSpawnDT = 0
	deliveryState = DeliveryState.SPAWNING
	
func calculateDeliveryPoints():
	var deliveryTargetTimeSeconds = capsuleDeliveryTargetTime * 60
	var deliveryTimePercentage = (deliveryTargetTimeSeconds-capsuleDeliveryDT)/deliveryTargetTimeSeconds
	if deliveryTimePercentage < 0:
		return
	var points = int((min(deliveryTimePercentage+.25, 1))/.25) * .25 * MAX_DELIVERY_POINTS
	deliveryPoints += points
	ptsSinceLastRank += points
	
@warning_ignore("integer_division")
func checkNextRank():
	while true:
		var rankDiff = RANKING_MAX - ranking
		var ptsForNextRank = pow(1.5, (1+(rankDiff/1000.0))) if rankDiff >= RANKING_MAX/2 else .125 * (5-int((500-rankDiff)/100))
		print("ranking: ", ranking)
		print("ptsForNextRank: ", ptsForNextRank)
		print("ptsSinceLastRank: ", ptsSinceLastRank)
		if ptsSinceLastRank >= ptsForNextRank:
			ptsSinceLastRank -= ptsForNextRank
			ranking -= 1
			mainMenuScreen.get_node("DeliveryStats/RankingText").text = "Your Rank: %d" % ranking
		else:
			break