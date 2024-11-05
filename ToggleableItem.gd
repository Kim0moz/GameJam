extends Node3D
class_name ToggleableItem

@export var anim : AnimationPlayer
@export var index : int
@export var animations : Array[Animation]

func _ready() -> void:
	activate()

func activate():
	anim.play(animations[index].resource_name)
	index = (index+1)%animations.size()
