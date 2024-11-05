extends Node3D

@onready var anim : AnimationPlayer = $"AnimationPlayer"
@export var toggle : bool = false
@export var cam : NavigationCamera
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate()
	cam.ActiveClicked.connect(activate)

func activate():
	if toggle == true:
		anim.play("Bottom")
	else:
		anim.play("Top2")
	toggle = !toggle
