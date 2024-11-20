@tool
extends Node3D
class_name PipeRegistration

@onready var grid : GridMap = get_parent()


@export var correctAnswer : int

@export_category("Edit Mode")
@export var EditMode : bool :
	set(val):
		EditMode = val
		ToggleEditMode(val)
@export var Register : bool :
	set(val):
		RegisterValues()

@export var DefaultValues : Array[Dictionary]
@export var CurrentInterface : int
@export var Interfaces : Dictionary

func RegisterValues():
	var tmp = grid.get_used_cells_by_item(6)
	if EditMode == false:
		DefaultValues.clear()
		for item in tmp:
			DefaultValues.append({item : grid.get_cell_item_orientation(item)})
	else:
		var tmpArray : Array[Dictionary]
		for item in tmp:
			tmpArray.append({item : grid.get_cell_item_orientation(item)})
		print(tmpArray)
		Interfaces.get_or_add(CurrentInterface,tmpArray)


func ToggleEditMode(val):
	if val == true:
		pass
	else:
		pass
		#for item in DefaultValues:
			#grid.set_cell_item(item.,6,item.item)
