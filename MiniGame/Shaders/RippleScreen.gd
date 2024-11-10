extends Panel

@export var mask : Panel
@export var cam : Camera2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("Click"):
			animateWave(event.position)
			

func setShaderTime(val):
	mask.material.set("shader_parameter/Time",val)

func animateWave(pos):
	var tween = get_tree().create_tween()
	mask.material.set("shader_parameter/Position",pos)
	tween.tween_method(setShaderTime,0.0,10.0,2)
