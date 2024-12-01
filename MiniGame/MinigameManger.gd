extends Node
class_name MinigameManager

@export_group("References")
@export var deliveryInfo : DeliveryInfo
@export var drone : Drone
@export var capsule : Capsule2D 
@export var pointer : Pointer2D
@export var dropOffGenerator : DropOffGenerator
@export var deliveryConfirmationText : PackedScene
@export var player : Player
@export var mainMenuScreen : Control
@export var antiDroneBotScene : PackedScene
@export var intersections : Node2D
@export var musicStream : AudioStreamPlayer3D
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
var ptsSinceLastRank = 0

@export_category("Glitch Delivery")
@export var glitchDeliveryAmount := 10
var hasTakenDamage := false
var hasGlitched := false
@onready var rng = RandomNumberGenerator.new()

@export_category("AntiDroneBot Spawning")
## When bots start spawning
var botSpawnRankThreshold := RANKING_MAX * .8
## How often to spawn bots 
@export var botSpawnTime := 40.0
## How many ranks before changing 
@export var botSpawnTimeChangeRank := 150
## How much to subtract from time every change
@export var botSpawnTimeChange := 3.0
var botSpawnTimeDT := 0.0
var lastBotSpawnRank : float

@export_category("Audio")
@export var playsAudio := true
@export var menuMusic : AudioStreamMP3
@export var gameMusic : AudioStreamMP3

var computerState : ComputerState = ComputerState.INACTIVE
var deliveryState : DeliveryState = DeliveryState.SPAWNING
enum ComputerState {INACTIVE, MAIN_MENU, MINIGAME}
enum DeliveryState {SPAWNING, PICKING_UP, DELIVERING, GLITCH}

# Called when the node enters the scene tree for the first time.
func _ready():
	capsuleSpawnPoints = get_tree().get_nodes_in_group("CapsuleSpawnPoints")
	drone.connect("package_acquired", Callable(self, "capsulePickedUp"))
	drone.connect("package_delivered", Callable(self, "capsuleDelivered"))
	drone.connect("damage_taken", Callable(self, "droneDamageTaken"))
	capsule.connect("glitch_delivery", Callable(self, "glitchActivated"))
	if player:
		player.connect("computer_enter", Callable(self, "computerEntered"))
		player.connect("computer_exit", Callable(self, "computerExited"))
	else:
		computerState = ComputerState.MAIN_MENU
	lastBotSpawnRank = botSpawnRankThreshold
	botSpawnTimeDT = botSpawnTime
	deliveryInfo.RankingLabel.text = "Rank: %d" % ranking

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
		DeliveryState.GLITCH:
			updateGlitch(delta)
	updateBotSpawn(delta)

func updateGlitch(delta):
	pass

func updateBotSpawn(delta):
	if ranking >= botSpawnRankThreshold:
		return
	
	botSpawnTimeDT += delta
	if botSpawnTimeDT >= botSpawnTime:
		var antiDroneBot = antiDroneBotScene.instantiate() as AntiDroneBot
		antiDroneBot.initialize(intersections)
		get_node("../").add_child(antiDroneBot)
		print("spawning antiDroneBot")
		botSpawnTimeDT = 0

		if lastBotSpawnRank - ranking >= botSpawnTimeChangeRank:
			lastBotSpawnRank = ranking
			botSpawnTime -= botSpawnTimeChange

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
	var delivConfText = (deliveryConfirmationText.instantiate() as DeliveryConfirmationText)
	if deliveryState == DeliveryState.GLITCH:
		hasGlitched = true
		delivConfText.global_position = pointer.target.global_position + Vector2(-delivConfText.size.x/2, -(delivConfText.size.y + 10))
		delivConfText.z_index = 100
		add_child(delivConfText)
		delivConfText.setCustomMessage("ERROR")
	else:
		delivConfText.global_position = pointer.target.global_position + Vector2(-delivConfText.size.x/2, -(delivConfText.size.y + 10))
		delivConfText.z_index = 100
		add_child(delivConfText)
		if capsuleDeliveryDT > capsuleDeliveryTargetTime * 60:
			delivConfText.setTextIndex(delivConfText.deliveryMessages.size() - 1)
		else:
			delivConfText.setTextIndex(int(deliveryInfo.TileSelected)-1)
		deliveryTotal += 1
		calculateDeliveryPoints()
		checkNextRank()

	pointer.target.queue_free()
	capsuleSpawnDT = 0
	deliveryInfo.setTextState(DeliveryInfo.TextState.FLASHING)
	deliveryState = DeliveryState.SPAWNING
	mainMenuScreen.get_node("DeliveryStats/DeliveryTotalText").text = "Today's Delivery Total: %d" % deliveryTotal
	mainMenuScreen.get_node("DeliveryStats/DeliveryPointText").text = "Today's Delivery Points: %d" % deliveryPoints
	if (deliveryTotal >= glitchDeliveryAmount or hasTakenDamage) and !hasGlitched:
		capsule.willGlitch = true

func glitchActivated():
	deliveryState = DeliveryState.GLITCH
	capsule.capsuleState = capsule.CapsuleState.NO_DELIVERY
	deliveryInfo.TimeLabel.text = "??:??"
	deliveryInfo.setTextState(DeliveryInfo.TextState.FLASHING)
	for i in range(30):
		deliveryInfo.DeliverStatusLabel.text = randomString("Delivery Status".length())
		deliveryInfo.RankingLabel.text = randomString(4, true)
		deliveryInfo.TileSelected = (int(deliveryInfo.TileSelected) + 1) % deliveryInfo.Tiles.size()
		pointer.target.queue_free()
		pointer.target = dropOffGenerator.generateDropOffPoint()
		await get_tree().create_timer(.08).timeout
	pointer.target.queue_free()
	pointer.target = dropOffGenerator.generateDropOffGlitch()
	deliveryInfo.DeliverStatusLabel.text = "RETURN ITEM"
	deliveryInfo.RankingLabel.text = "Rank: %d" % ranking
	capsule.capsuleState = capsule.CapsuleState.SPAWNED

func randomString(length : int, numbersOnly : bool = false) -> String:
	var randString := ""
	for i in range(length):
		if numbersOnly:
			randString += char(rng.randi_range(48, 57))
		else:
			randString += char(rng.randi_range(33, 126))
	return randString

func droneDamageTaken():
	if drone.package != null:
		pointer.target.queue_free()
		drone.package = null
		capsule.setToIdle()
		capsuleSpawnDT = 0
		deliveryState = DeliveryState.SPAWNING
	var delivConfText = (deliveryConfirmationText.instantiate() as DeliveryConfirmationText)
	delivConfText.setCustomMessage("OUCH!")
	delivConfText.global_position = drone.global_position + Vector2(-delivConfText.size.x/2, -(delivConfText.size.y + 10))
	delivConfText.z_index = 100
	hasTakenDamage = true
	if !hasGlitched:
		capsule.willGlitch = true
	add_child(delivConfText)

func computerEntered():
	computerState = ComputerState.MAIN_MENU
	mainMenuScreen.set_process(true)
	mainMenuScreen.visible = true

func computerExited():
	computerState = ComputerState.INACTIVE
	mainMenuScreen.set_process(true)
	mainMenuScreen.visible = true
	drone.droneState = Drone.DroneState.NO_CONTROLS
	drone.resetDrone()
	if pointer.target != null and pointer.target != capsule:
		pointer.target.queue_free()
	else:
		pointer.target = null
	deliveryInfo.TileSelected = DeliveryInfo.DeliveryStatus.CAPSULE_PICKUP
	deliveryInfo.TimeLabel.text = "00:00"
	deliveryInfo.setTextState(DeliveryInfo.TextState.STABLE)
	capsule.capsuleState = Capsule2D.CapsuleState.IDLE
	capsule.modulate.a = 0
	if playsAudio:
		musicStream.stream = menuMusic
		musicStream.play()

func startGame():
	computerState = ComputerState.MINIGAME
	mainMenuScreen.set_process(false)
	mainMenuScreen.visible = false
	drone.droneState = Drone.DroneState.NO_PACKAGE
	capsuleSpawnDT = 0
	deliveryState = DeliveryState.SPAWNING
	if playsAudio:
		musicStream.stream = gameMusic
		musicStream.play()
	
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
	if ranking == 1:
		return
	while true:
		var rankDiff = RANKING_MAX - ranking
		var ptsForNextRank = pow(1.5, (1+(rankDiff/1000.0))) if rankDiff >= RANKING_MAX/2 else .125 * (5-int((500-rankDiff)/100))
		# print("ranking: ", ranking)
		# print("ptsForNextRank: ", ptsForNextRank)
		# print("ptsSinceLastRank: ", ptsSinceLastRank)
		if ptsSinceLastRank >= ptsForNextRank && ranking > 1:
			ptsSinceLastRank -= ptsForNextRank
			ranking -= 1
			mainMenuScreen.get_node("DeliveryStats/RankingText").text = "Your Rank: %d" % ranking
			deliveryInfo.RankingLabel.text = "Rank: %d" % ranking
		else:
			print("ranking: ", ranking)
			break
