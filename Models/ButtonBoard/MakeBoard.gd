extends Node3D

@export var button : PackedScene
@onready var buttons = $"Buttons"
@export var buttonData : Array[Dictionary] = [{"transform": Vector3(0,0,0), "rotations": [11,15,3,07]}]
@export var grid : GridMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func build_grid():
	var index = 0
	for butts in buttons.get_children():
		butts.free()
	for butt in buttonData:
		var tmp : Node3D = button.instantiate()
		add_child(tmp)
		tmp.name = str(buttons.get_child_count())
		tmp.position = Vector3(0-2,0,0)
		index+=1
		
