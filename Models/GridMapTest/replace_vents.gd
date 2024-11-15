@tool
extends "res://Models/GridMapTest/ReplaceWithInteractive.gd"

@export var data : Dictionary
@export var interactive : Array[Dictionary]
@export var player : Node3D
@export var getNodes : bool : 
	set(val):
		getInteractive()

func _ready() -> void:
	if Engine.is_editor_hint() == false:
		for itm in interactive:
			var replace = item.instantiate()
			replace.player = player
			replace.name = str(itm.transform)
			add_child(replace)
			itm.Self = replace.get_path()
			(replace as Node3D).global_basis = gridMap.get_cell_item_basis(itm.transform)
			(replace as Node3D).global_position = gridMap.map_to_local(itm.transform) + gridMap.global_position
			gridMap.set_cell_item(itm.transform,-1)
		for itm in interactive:
			get_node(itm.Self).Data.Exit = getExitPoint(itm.Exit)
		
func getInteractive():
	var itms = gridMap.get_used_cells_by_item(itemToReplace)
	interactive.clear()
	for itm in itms:
		print(itm)
		interactive.append(data.duplicate())
		interactive[interactive.size()-1].transform = itm

func getExitPoint(t : Vector3i):
	for itm in interactive:
		if t == itm.transform:
			print(itm.Exit)
			return itm.Self
