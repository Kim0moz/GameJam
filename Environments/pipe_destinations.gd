@tool
extends GridMap
class_name PipeDestinations


@export var Ends : Array

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

func _ready() -> void:
	getEnds()
	updateSelection()


func getEnds():
	Ends = self.get_used_cells()


func updateSelection():
	self.clear()
	if Engine.is_editor_hint():
		for item in Ends:
			self.set_cell_item(item.Position,0)
