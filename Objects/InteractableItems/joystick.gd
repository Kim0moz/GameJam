@tool
extends Node3D


@onready var AnimTree : AnimationTree = $"AnimationTree"

@export var CurrentDirection : Vector2 = Vector2(0.0,0.0) :
	set(value):
		CurrentDirection = Vector2(clampf(value.x,-1.0,1.0),clampf(value.y,-1.0,1.0))
		if AnimTree:
			AnimTree["parameters/Axes/blend_position"] = CurrentDirection

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
