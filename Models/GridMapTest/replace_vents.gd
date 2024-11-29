@tool
extends "res://Models/GridMapTest/ReplaceWithInteractive.gd"

@export var interactive : Array[Vector3i]
@export var player : Node3D
@export var replaceVents : bool:
	set(val):
		updateVents()
@export var getNodes : bool : 
	set(val):
		getInteractive()

func _ready() -> void:
	pass
		
func getInteractive():
	var itms = gridMap.get_used_cells_by_item(itemToReplace)
	interactive.clear()
	for itm in itms:
		interactive.append(itm)

func updateVents():
	for itm in interactive:
		var replace = item.instantiate()
		replace.player = player
		add_child(replace)
		replace.owner = get_tree().edited_scene_root
		replace.name = str(itm)
		(replace as Node3D).global_basis = gridMap.get_cell_item_basis(itm)
		(replace as Node3D).global_position = gridMap.map_to_local(itm) + gridMap.global_position
		gridMap.set_cell_item(itm,-1)
