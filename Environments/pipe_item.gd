@tool
extends Node3D
class_name PipeItem


@export var Fire : bool :
	set(val):
		nextPos()
@onready var pipeMesh = $Item
var currentCell

@export_category("Current Cell Info")
@export var ActiveDirections : Array
@export var CurrentPos : Vector3i = Vector3i(-2,-1,-1):
	set(val):
		moveToGridLocation(val)
		CurrentPos = val
		updatePipeDetails()
@export var CurrentDirection = Vector3i(0,0,0)

@export_category("Linked Nodes")
@export var Grid : GridMap
@export var pipeDirection : PipeSupport
@export var pipeDestinations : PipeDestinations



func _ready() -> void:
	await get_tree().root.ready
	moveToGridLocation(CurrentPos)

func nextPos():
	updatePipeDetails()
	CurrentPos = CurrentPos+CurrentDirection

func updatePipeDetails():
	if get_tree():
		currentCell = Grid.get_cell_item(CurrentPos)
		ActiveDirections = pipeDirection.activeDirections(currentCell,Grid.get_cell_item_orientation(CurrentPos))
		calculateNextDirection()
	
func checkIfNextIsPossible(direction):
	var nextCell = Grid.get_cell_item(CurrentPos+direction)
	var nextDirections : Array = pipeDirection.activeDirections(nextCell,Grid.get_cell_item_orientation(CurrentPos+direction))
	#print(nextDirections)
	if nextDirections.has(direction*-1) and nextCell != -1:
		#print("Can Move")
		return true
	else:
		return false

func calculateNextDirection():
	var preferredDirections = [
	Vector3i(pipeMesh.basis.x),
	Vector3i(-pipeMesh.basis.x),
	Vector3i(pipeMesh.basis.z),
	Vector3i(-pipeMesh.basis.z),
	Vector3i(pipeMesh.basis.y),
	Vector3i(-pipeMesh.basis.y),
]
	#print("Calculating From :", CurrentPos)
	if (ActiveDirections as Array).has(CurrentDirection):
		if checkIfNextIsPossible(CurrentDirection) == true:
			#print("Continuing Same Path")
			return
	else:
		for dir in preferredDirections:
			print(dir)
			print(CurrentDirection)
			if (ActiveDirections as Array).has(dir) and dir != CurrentDirection*-1:
				#print("Checking : ", dir)
				if checkIfNextIsPossible(dir) == true:
					CurrentDirection = (dir) 
					#print("Found Direction")
					return
	#print("Didn't Find Direction")
	if CurrentDirection == Vector3i.ZERO:
		CurrentDirection = ActiveDirections.pick_random()
	else:
		CurrentDirection = CurrentDirection*-1

func moveToGridLocation(location : Vector3i):
	if CurrentPos == location or not get_tree():
		return
	var tween = get_tree().create_tween()
	tween.set_trans(tween.TRANS_LINEAR)
	tween.tween_property(self,"global_position",Grid.local_to_map(location) as Vector3,.1)
	var pipe = pipeDestinations.checkIfExists(location)
	CurrentDirection  =  ((location-CurrentPos)as Vector3i).clamp(Vector3i(-1,-1,-1),Vector3i(1,1,1))
	if(not pipe):
		tween.finished.connect(nextPos)
	else:
		CurrentDirection = pipe
	pipeMesh.global_basis =  Grid.get_cell_item_basis(location)
