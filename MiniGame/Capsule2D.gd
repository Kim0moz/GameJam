extends Area2D
class_name Capsule2D

var onScreen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnRandomly()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onBodyEntered(body):
	print(body.name)

func spawnRandomly():
	position = get_tree().get_nodes_in_group("CapsuleSpawnPoints").pick_random().position


func screenEntered():
	onScreen = true
	print("Screen Entered")

func screenExited():
	onScreen = false
	print("Screen Exited")