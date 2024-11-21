@tool
extends Node3D
class_name PipeDestinations


@onready var Grid : GridMap = self.get_parent()
@export var Ends : Array

@export var clear : bool = false
@export var run : bool :
	set(val):
		getEnds()

var DirectionsToCheck = [
	Vector3i(1,0,0),
	Vector3i(0,1,0),
	Vector3i(0,0,1),
	Vector3i(-1,0,0),
	Vector3i(0,-1,0),
	Vector3i(0,0,-1),
]


func getEnds():
	var usedCells = Grid.get_used_cells()
	if clear:
		Ends.clear()
	for cell in usedCells:
		var usedDirections = 0
		for dir in DirectionsToCheck:
			if Grid.get_cell_item(cell+dir) != -1:
				usedDirections += 1
		if usedDirections < 2:
			Ends.append(cell)
