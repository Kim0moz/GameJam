extends ScrollContainer

var scrollV = 0

func _gui_input(event: InputEvent) -> void:
	scroll_vertical += scrollV
	scrollV*=0.8
	if Input.is_action_just_released("scroll_up"):
		scrollV-=15
	elif Input.is_action_just_released("scroll_down"):
		scrollV+=15
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("Click"):
			scrollV -= event.velocity.y/150
