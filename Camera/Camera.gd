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
## Time in milliseconds that crosshair stays as "SelectedItem" texture
@export var selectedItemDelay : int = 250
var mousePos = Vector2.ZERO
var itemSelected = false
var itemSelectedTime = 0

func _ready() -> void:
	Reticle.texture = Default
	
func _process(delta):
	var worldPos = self.project_position(mousePos,5)
	ray.look_at(worldPos)
	if ray.is_colliding():
		if objectSelected != ray.get_collider():
			if objectSelected is InteractableItem:
				objectSelected.Exit.emit()
			objectSelected = ray.get_collider()
			mousePoint = ray.get_collision_point() + Vector3(0,.01,0)
		else:
			if objectSelected is InteractableItem:
				if Input.is_action_just_pressed("Click"):
					Reticle.texture = SelectedItem
					objectSelected.Activated.emit()
					itemSelected = true
					itemSelectedTime = Time.get_ticks_msec()
				elif !itemSelected:
					objectSelected.Hovered.emit()
					Reticle.texture = SelectableItem
			else:
				Reticle.texture = Default
	else:
		Reticle.texture = Default

	if itemSelected && Time.get_ticks_msec() - itemSelectedTime >= selectedItemDelay:
		itemSelected = false

func _input(event):
	if event is InputEventMouseMotion:
		mousePos = event.position
		
