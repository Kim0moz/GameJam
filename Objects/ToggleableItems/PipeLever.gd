extends Node3D
class_name pipeLever

@onready var lever  = $'Lever'
@export var pI : PipeRegistration

func _ready() -> void:
	lever.Activated.connect(Toggle)

func Toggle():
	pI.CurrentInterface = (pI.CurrentInterface + 1)%(pI.Interfaces.size()-1)
