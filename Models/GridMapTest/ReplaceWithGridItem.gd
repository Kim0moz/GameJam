extends Node3D

@onready var gridMap : GridMap = get_parent()
@export var itemToReplace : int
@export var item : int


func _ready() -> void:
	pass
		


func _on_button_board_2_buttons_made() -> void:
	var itms = gridMap.get_used_cells_by_item(itemToReplace)
	for itm in itms:
		var ori =  gridMap.get_cell_item_orientation(itm)
		gridMap.set_cell_item(itm,item,ori)
