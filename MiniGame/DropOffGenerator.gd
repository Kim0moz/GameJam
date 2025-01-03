extends TileMapLayer
class_name DropOffGenerator

@export var dropOffPoint : PackedScene
@export var doorTileAtlasCoords : Vector2i = Vector2i(1, 5)
@export var dropOffOffsetY : float = 20
var currentDropOff

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generateDropOffPoint() -> DeliveryTarget:
	var doorTilePositions = []
	for tilePosition in get_used_cells():
		if get_cell_atlas_coords(tilePosition) == doorTileAtlasCoords:
			doorTilePositions.append(tilePosition)

	var doorTilePos = doorTilePositions.pick_random()
	currentDropOff = (dropOffPoint.instantiate() as DeliveryTarget)
	var dropOffPosition = Vector2(doorTilePos.x * tile_set.tile_size.x + tile_set.tile_size.x / 2.0, doorTilePos.y * tile_set.tile_size.y + dropOffOffsetY)
	currentDropOff.position = dropOffPosition
	add_child(currentDropOff)
	return currentDropOff

func generateDropOffGlitch() -> DeliveryTarget:
	currentDropOff = (dropOffPoint.instantiate() as DeliveryTarget)
	add_child(currentDropOff)
	currentDropOff.global_position = get_tree().get_nodes_in_group("CapsuleSpawnPoints").pick_random().global_position
	return currentDropOff
