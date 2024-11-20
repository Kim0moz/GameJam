@tool
extends Node3D


@export var Grid : GridMap
@export var CurrentPos : Vector3i = Vector3i(-2,-1,-1)
@export var Next : bool
@export var Previous : bool

func _ready() -> void:
	moveToGridLocation(CurrentPos)

func nextPos():
	return false

func moveToGridLocation(location : Vector3i):
	self.global_position = Grid.local_to_map(location)
	self.global_basis =  Grid.get_cell_item_basis(location)
