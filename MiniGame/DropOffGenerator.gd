extends TileMapLayer

@export var dropOffPoint : PackedScene
@export var doorTileAtlasCoords : Vector2i = Vector2i(1, 5)
@export var dropOffOffsetY : float = 20
var currentDropOff

# Called when the node enters the scene tree for the first time.
func _ready():
	generateDropOffPoint(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generateDropOffPoint(pointer : Pointer2D):
	print("Generating Drop Offs")
	var doorTilePositions = []
	for tilePosition in get_used_cells():
		if get_cell_atlas_coords(tilePosition) == doorTileAtlasCoords:
			doorTilePositions.append(tilePosition)

	var doorTilePos = doorTilePositions.pick_random()
	currentDropOff = (dropOffPoint.instantiate() as DeliveryTarget)
	var dropOffPosition = Vector2(doorTilePos.x * tile_set.tile_size.x + tile_set.tile_size.x / 2.0, doorTilePos.y * tile_set.tile_size.y + dropOffOffsetY)
	currentDropOff.position = dropOffPosition
	add_child(currentDropOff)
	# if pointer != null:
	# 	pointer.target = currentDropOff
	print("Drop Off Generated")
	
