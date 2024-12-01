extends Node3D
class_name pipeLever

@onready var lever  = $'Lever'
@export var pI : PipeRegistration
@export var Lights : Node3D
var lightChildren

func _ready() -> void:
	lightChildren = Lights.get_children()
	lever.Activated.connect(Toggle)
	lever.Hovered.connect(Hover)
	lever.Exit.connect(Exit)

func Toggle():
	print("Activated")
	$Click.play()
	pI.CurrentInterface = (pI.CurrentInterface + 1)%(pI.Interfaces.size())

func Hover():
	var interface = pI.Interfaces[pI.CurrentInterface]
	var ltIndx = 0
	for pipes in interface:
		lightChildren[ltIndx].visible = true
		lightChildren[ltIndx].global_position = pI.grid.map_to_local(pipes.Position) + pI.grid.global_position
		ltIndx+=1
	pass

func Exit():
	for light in lightChildren:
		(light as Node3D).position = Vector3.ZERO
