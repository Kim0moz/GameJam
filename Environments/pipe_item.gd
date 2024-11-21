@tool
extends Node3D


@export var Grid : GridMap
@export var CurrentPos : Vector3i = Vector3i(-2,-1,-1):
	set(val):
		moveToGridLocation(val)
		CurrentDirection  =  ((val-CurrentPos)as Vector3i).clamp(Vector3i(-1,-1,-1),Vector3i(1,1,1))
		CurrentPos = val
		updatePipeDetails()
@export var Next : bool :
	set(val):
		nextPos()
@export var Previous : bool :
	set(val):
		prePos()
@export var pipeDirection : PipeSupport

@onready var pipeMesh = $Item
var tween

var currentCell
@export var ActiveDirections : Array
@export var CurrentDirection = Vector3i(0,0,0)
@export var LastDirection = Vector3i(0,0,0)

var preferredDirections = [
	Vector3i(0,1,0),
	Vector3i(0,0,1),
	Vector3i(1,0,0),
	Vector3i(0,-1,0),
	Vector3i(0,0,-1),
	Vector3i(-1,0,0)
]

func _ready() -> void:
	moveToGridLocation(CurrentPos)

func nextPos():
	updatePipeDetails()
	CurrentPos = CurrentPos+CurrentDirection
	
func prePos():
	updatePipeDetails()
	CurrentPos = CurrentPos-CurrentDirection

func updatePipeDetails():
	currentCell = Grid.get_cell_item(CurrentPos)
	ActiveDirections = pipeDirection.activeDirections(currentCell,Grid.get_cell_item_orientation(CurrentPos))
	calculateNextDirection()
	
func checkIfNextIsPossible(direction):
	var nextCell = Grid.get_cell_item(CurrentPos+direction)
	var nextDirections : Array = pipeDirection.activeDirections(nextCell,Grid.get_cell_item_orientation(CurrentPos+direction))
	#print(nextDirections)
	if nextDirections.has(direction*-1):
		#print("Can Move")
		return true
	else:
		return false

func calculateNextDirection():
	print("Calculating From :", CurrentPos)
	if (ActiveDirections as Array).has(CurrentDirection):
		if checkIfNextIsPossible(CurrentDirection) == true:
			#print("Continuing Same Path")
			return
	else:
		for dir in preferredDirections:
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
	if CurrentPos == location:
		return
	tween = get_tree().create_tween()
	tween.set_trans(tween.TRANS_LINEAR)
	tween.tween_property(self,"global_position",Grid.local_to_map(location) as Vector3,.1)
	if(location != Vector3i(5,-1,-1)):
		tween.finished.connect(nextPos)
	#self.global_position = Grid.local_to_map(location)
	pipeMesh.global_basis =  Grid.get_cell_item_basis(location)
