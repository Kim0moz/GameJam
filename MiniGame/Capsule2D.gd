extends Area2D
class_name Capsule2D

var onScreen = false
var drone : Drone

# Called when the node enters the scene tree for the first time.
func _ready():
	# spawnRandomly()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onBodyEntered(body):
	if body.name == "Drone":
		(body as Drone).setStateDelivering(self)
		drone = body
		
func onAreaEntered(area):
	if area.name.contains("DeliveryTarget"):
		area.queue_free()
		drone.setStateNoPackage()
		spawnRandomly()

func spawnRandomly():
	position = get_tree().get_nodes_in_group("CapsuleSpawnPoints").pick_random().position


func screenEntered():
	onScreen = true

func screenExited():
	onScreen = false