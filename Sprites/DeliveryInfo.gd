@tool
extends HBoxContainer
class_name DeliveryInfo

@export var Tiles : Array[Texture2D]
@onready var Icon : TextureRect = $Icon/TextureRect
@export var TileSelected : DeliveryStatus :
	set(val):
		Icon.texture = Tiles[val]
		TileSelected = val
	get:
		return TileSelected
@onready var TimeLabel : Label = $TimeText/Label
enum DeliveryStatus {CAPSULE_PICKUP, GOOD, OKAY, BAD, URGENT}
var textState := TextState.STABLE
enum TextState {STABLE, FLASHING}
var flashingDT := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match textState:
		TextState.STABLE:
			TimeLabel.modulate.a = 1
			flashingDT = 0
		TextState.FLASHING:
			flashingDT += delta
			TimeLabel.modulate.a = 0 if (int(flashingDT * 10) % 6 < 3) else 1

func setTextState(tState : TextState):
	textState = tState
