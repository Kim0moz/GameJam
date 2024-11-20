@tool
extends Node3D
class_name PipeRegistration

@onready var grid : GridMap = get_parent()

@export var CurrentInterface : int :
	set(val):
		CurrentInterface = val
		updatePipes()

@export_category("Edit Mode")
@export var Register : bool :
	set(val):
		RegisterValues()
@export var Interfaces : Dictionary

func _ready() -> void:
	updatePipes()

func RegisterValues():
	var tmp = grid.get_used_cells_by_item(6)
	var tmpArray : Array[Dictionary]
	for item in tmp:
		tmpArray.append({
			"Orientation" : grid.get_cell_item_orientation(item),
			"Position" : item
			})
	print(tmpArray)
	Interfaces.get_or_add(CurrentInterface,tmpArray)

func updatePipes():
	var pipe = 1
	if Engine.is_editor_hint():
		pipe = 6
	if Interfaces.has(CurrentInterface):
		for item in Interfaces[CurrentInterface]:
			grid.set_cell_item(item.Position,pipe,item.Orientation)
