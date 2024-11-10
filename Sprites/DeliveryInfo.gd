@tool
extends HBoxContainer

@export var Tiles : Array[Texture2D]
@onready var Icon : TextureRect = $Icon/TextureRect
@export_range(0,4) var TileSelected : int :
	set(val):
		Icon.texture = Tiles[val]
		TileSelected = val
	get:
		return TileSelected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
