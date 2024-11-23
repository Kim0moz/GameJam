@tool
extends GridMap
class_name PipeDestinations


@export var Ends : Array

@export var remake : bool :
	set(val):
		getEnds()

@export var addNew : bool :
	set(val):
		addNewEnds()

var DirectionsToCheck = [
	Vector3i(1,0,0),
	Vector3i(0,1,0),
	Vector3i(0,0,1),
	Vector3i(-1,0,0),
	Vector3i(0,-1,0),
	Vector3i(0,0,-1),
]

func _ready() -> void:
	updateSelection()


func getEnds():
	Ends.clear()
	var tmp = self.get_used_cells()
	for itm in tmp:
		Ends.append({"Position": itm, "Direction": Vector3i(0,0,0)})
		
func addNewEnds():
	var tmp = self.get_used_cells()
	for itm in tmp:
		if checkIfExists(itm) == false:
			Ends.append({"Position": itm, "Direction": Vector3i(0,0,0)})
		
func checkIfExists(pos):
	for end in Ends:
			if end.Position == pos:
				print(end.Direction)
				return end.Direction
	return

func updateSelection():
	self.clear()
	if Engine.is_editor_hint():
		for item in Ends:
			self.set_cell_item(item.Position,0)
