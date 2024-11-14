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
		var itms = gridMap.get_used_cells_by_item(itemToReplace)
		for itm in itms:
			var replace = item.instantiate()
			replace.player = player
			replace.name = str(itm)
			add_child(replace)
			(replace as Node3D).global_basis = gridMap.get_cell_item_basis(itm)
			(replace as Node3D).global_position = gridMap.map_to_local(itm) - Vector3(0,0,0)
			gridMap.set_cell_item(itm,-1)
		
func getInteractive():
	var itms = gridMap.get_used_cells_by_item(itemToReplace)
	interactive.clear()
	for itm in itms:
		print(itm)
		interactive.append(data.duplicate())
		interactive[interactive.size()-1].transform = itm
