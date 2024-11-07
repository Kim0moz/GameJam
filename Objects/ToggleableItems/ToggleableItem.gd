extends InteractableItem
class_name ToggleableItem

@export var anim : AnimationPlayer
@export var index : int
@export var animations : Array[Animation]
var playing : bool = false

func _ready() -> void:
	anim.connect("animation_finished", Callable(self, "anim_finished"))
	activate()

func activate(mousePos = Vector2.ZERO):
	if playing == true:
		return
	anim.play(animations[index].resource_name)
	playing = true
	index = (index+1)%animations.size()

func anim_finished(anim_name):
	print("anim finished: ", self.name, " - ", anim_name)
	playing = false
