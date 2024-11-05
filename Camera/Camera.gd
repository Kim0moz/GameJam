extends Camera3D
class_name NavigationCamera

@onready var ray = $RayCast3D
@export var mousePoint : Vector3
@export var objectSelected : Node3D
var mousePos = Vector2.ZERO

	
func _process(delta):
	var worldPos = self.project_position(mousePos,5)
	ray.look_at(worldPos)
	if ray.is_colliding():
		objectSelected = ray.get_collider()
		mousePoint = ray.get_collision_point() + Vector3(0,.2,0)
		print(objectSelected.name)

func _input(event):
	if event is InputEventMouseMotion:
		mousePos = event.position
	if event.is_action_released("Click") and ray.is_colliding():
		if objectSelected is ToggleableItem:
			objectSelected.activate()
