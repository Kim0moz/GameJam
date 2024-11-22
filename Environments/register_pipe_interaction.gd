@tool
extends GridMap
class_name PipeRegistration

@export var grid : GridMap 

@export var CurrentInterface : int :
	set(val):
		CurrentInterface = val
		updatePipes()

@export_category("Edit Mode")

@export var Register : bool :
	set(val):
		RegisterValues()
@export var Interfaces : Dictionary
@export_category("Erase")
@export var clearInterface : bool:
	set(val):
		Interfaces.erase(CurrentInterface)
@export var clearAll : bool:
	set(val):
		Interfaces.clear()

func _ready() -> void:
	updatePipes()
	if Engine.is_editor_hint() == false:
		self.clear()

func RegisterValues():
	var registration = self.get_used_cells()
	var tmpArray : Array[Dictionary]
	Interfaces.erase(CurrentInterface)
	for item in registration:
		tmpArray.append({
			"Orientation" : grid.get_cell_item_orientation(item),
			"Position" : item,
			"Pipe" : grid.get_cell_item(item)
			})
	print(tmpArray)
	Interfaces.get_or_add(CurrentInterface,tmpArray)

func updatePipes():
	if Engine.is_editor_hint():
		updateSelection()
	print(CurrentInterface)
	if Interfaces.has(CurrentInterface):
		for item in Interfaces[CurrentInterface]:
			grid.set_cell_item(item.Position,item.Pipe,item.Orientation)
			
func updateSelection():
	if Interfaces.has(CurrentInterface):
		self.clear()
		if Engine.is_editor_hint():
			for item in Interfaces[CurrentInterface]:
				self.set_cell_item(item.Position,0)
