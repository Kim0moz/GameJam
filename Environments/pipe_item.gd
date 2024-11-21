@tool
extends Node3D


@export var Grid : GridMap
@export var CurrentPos : Vector3i = Vector3i(-2,-1,-1):
	set(val):
		CurrentPos = val
		moveToGridLocation(val)
@export var Next : bool :
	set(val):
		nextPos()
@export var Previous : bool :
	set(val):
		prePos()
@export var pipeDirection : PipeSupport

@onready var pipeMesh = $Item


var currentCell
var ActiveDirections
var lastDirection = Vector3(0,0,0)

func _ready() -> void:
	moveToGridLocation(CurrentPos)

func nextPos():
	moveToGridLocation(CurrentPos+ActiveDirections[1])
	lastDirection = ActiveDirections[1]
	
func prePos():
	moveToGridLocation(CurrentPos+ActiveDirections[0])
	lastDirection = ActiveDirections[0]

func updatePipeDetails():
	var currentCell = Grid.get_cell_item(CurrentPos)
	ActiveDirections = pipeDirection.activeDirections(currentCell,Grid.get_cell_item_orientation(CurrentPos))

func calculateNextDirection():
	pass

func moveToGridLocation(location : Vector3i):
	if CurrentPos == location:
		return
	CurrentPos = location
	self.global_position = Grid.local_to_map(location)
	pipeMesh.global_basis =  Grid.get_cell_item_basis(location)
	updatePipeDetails()
