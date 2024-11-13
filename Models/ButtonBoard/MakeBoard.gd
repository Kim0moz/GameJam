@tool
extends Node3D

@export var button : PackedScene
@export var buttons : Node3D
@export var buttonData : Array[Dictionary] = [{"transform": Vector3(0,0,0), "rotations": [11,15,3,07]}]
@export var grid : GridMap
@export var columns : int = 4

@export var yOffset : float = 0:
	set(val):
		yOffset = val
		build_grid()
@export var zOffset : float = 0:
	set(val):
		zOffset = val
		build_grid()
@export var zPadding : float = 0:
	set(val):
		zPadding = val
		build_grid()
@export var yPadding : float = 0:
	set(val):
		yPadding = val
		build_grid()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_add_data(16)
	build_grid()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_data(amount: int):
	buttonData.clear()
	for i in range(amount):
		buttonData.append({"transform": Vector3(0,0,0), "rotations": [11,15,3,07]})

func build_grid():
	var index = 0
	if buttons:
		for butts in buttons.get_children():
			butts.free()
	for butt in buttonData:
		if butt.transform != Vector3.ZERO:
			var tmp : pipeLever = button.instantiate()
			buttons.add_child(tmp,true)
			tmp.name = str(buttons.get_child_count())
			tmp.set_owner(self)
			tmp.grid = grid
			tmp.rots = butt.rotations 
			tmp.PipeIndex = butt.transform
			tmp.position = Vector3(.1,yOffset+floor(index/columns)/yPadding,zOffset+(index%columns)/zPadding)
		index+=1
		
