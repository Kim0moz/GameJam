extends Node3D

@onready var lever  = $'Lever'
@export var grid : GridMap
@export var itemIndex : int
@export var PipeIndex : Vector3
var index : int = 0
@export var Positions : Array[int]

func _ready() -> void:
	lever.Activated.connect(Toggle)

func Toggle():
	grid.set_cell_item(PipeIndex,itemIndex,Positions[index])
	index = (index+1)%Positions.size()
	
	
