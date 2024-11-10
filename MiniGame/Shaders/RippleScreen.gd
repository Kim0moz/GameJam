extends Control

@export var mask : Panel
@export var cam : Camera2D
@export var source : Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("Click"):
			animateWave(event.position)
			
func _process(delta: float) -> void:
	if source:
		animateWave(source.get_screen_transform().origin+Vector2(50,20))

func animateWave(pos):
	mask.material.set("shader_parameter/Position",pos)
