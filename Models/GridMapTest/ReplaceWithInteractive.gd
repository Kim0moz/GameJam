extends Node3D

@onready var gridMap : GridMap = get_parent()
@export var itemToReplace : int
@export var item : PackedScene


func _ready() -> void:
	var itms = gridMap.get_used_cells_by_item(itemToReplace)
	for itm in itms:
		var replace = item.instantiate()
		replace.name = str(itm)
		add_child(replace)
		(replace as Node3D).global_basis = gridMap.get_cell_item_basis(itm)
		(replace as Node3D).global_position = gridMap.map_to_local(itm) - Vector3(0,.5,0)
		gridMap.set_cell_item(itm,-1)
		
