extends Node3D
class_name pipeLever

@onready var lever  = $'Lever'
@export var grid : GridMap
@export var itemIndex : int
@export var PipeIndex : Vector3
var index : int = 0
@export var rots : Array

func _ready() -> void:
	lever.Activated.connect(Toggle)

func Toggle():
	grid.set_cell_item(PipeIndex,itemIndex,rots[index])
	index = (index+1)%rots.size()
	
