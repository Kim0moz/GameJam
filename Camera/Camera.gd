extends Camera3D
class_name NavigationCamera

@onready var ray = $RayCast3D
@export var mousePoint : Vector3
@export var objectSelected : Node3D

@export_group("Crossheir")
@export var Reticle : TextureRect
@export var Default : Texture2D
@export var SelectableItem : Texture2D
@export var SelectedItem : Texture2D
var mousePos = Vector2.ZERO

func _ready() -> void:
	Reticle.texture = Default
	
func _process(delta):
	var worldPos = self.project_position(mousePos,5)
	ray.look_at(worldPos)
	if ray.is_colliding():
		objectSelected = ray.get_collider()
		mousePoint = ray.get_collision_point() + Vector3(0,.01,0)
		if objectSelected is InteractableItem and Input.is_action_pressed("Click") == false:
			Reticle.texture = SelectableItem
		elif objectSelected is InteractableItem:
			Reticle.texture = SelectedItem
			objectSelected.activate(mousePos)
		else:
			Reticle.texture = Default
		# print(objectSelected.name)

func _input(event):
	if event is InputEventMouseMotion:
		mousePos = event.position
		
