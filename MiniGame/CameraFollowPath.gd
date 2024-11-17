extends Path2D
class_name CameraFollowPath

@export var camera : Camera2D

func _ready():
	update_path()

func _process(delta):
	update_path()

func update_path():
	var viewport_size = get_viewport_rect().size / (camera.zoom * 1.5)

	var top_left = camera.global_position - viewport_size / 2
	var top_right = camera.global_position + Vector2(viewport_size.x / 2, -viewport_size.y / 2)
	var bottom_right = camera.global_position + viewport_size / 2
	var bottom_left = camera.global_position + Vector2(-viewport_size.x / 2, viewport_size.y / 2)

	curve.clear_points()
	curve.add_point(bottom_right)
	curve.add_point(top_right)
	curve.add_point(top_left)
	curve.add_point(bottom_left)
	curve.add_point(bottom_right)

