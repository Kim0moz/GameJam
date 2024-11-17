extends Area2D
class_name Capsule2D

var onScreen = false
var drone : Drone

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnRandomly()


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
		drone.setStateNoDelivery()
		spawnRandomly()

func spawnRandomly():
	position = get_tree().get_nodes_in_group("CapsuleSpawnPoints").pick_random().position
	(get_tree().get_nodes_in_group("Pointer2D")[0] as Pointer2D).target = self


func screenEntered():
	onScreen = true

func screenExited():
	onScreen = false