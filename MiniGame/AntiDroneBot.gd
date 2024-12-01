extends Area2D

@export var intersectionsNode : Node2D
@export var moveSpeed := 5.0
var intersectionsGrid = []
var currRow = 0
var currCol = 0
var targetIntersection : Area2D
var rng = RandomNumberGenerator.new()
var moveVector : Vector2
var ignoreArea = true

# Called when the node enters the scene tree for the first time.
func _ready():
	initializeGrid()
	spawnAtRandomIntersection()
	pickNextIntersection()


func initializeGrid():
	for i in range(intersectionsNode.get_child_count() / 4):
		intersectionsGrid.append([])
		for j in range(4):
			intersectionsGrid[i].append(intersectionsNode.get_child(i*4+j))
			
func spawnAtRandomIntersection():
	currRow = rng.randi_range(0, intersectionsGrid.size()-1)
	currCol = rng.randi_range(0, intersectionsGrid[0].size()-1)
	global_position = intersectionsGrid[currRow][currCol].global_position
	print(intersectionsGrid[currRow][currCol].name)

func pickNextIntersection():
	if randi_range(0,1) == 0: 
		if currRow == 0:
			currRow += 1
		elif currRow == intersectionsGrid.size() - 1:
			currRow -= 1
		else:
			currRow += -1 if rng.randi_range(0,1) == 0 else 1
	else:
		if currCol == 0:
			currCol += 1
		elif currCol == intersectionsGrid[0].size() - 1:
			currCol -= 1
		else:
			currCol += -1 if rng.randi_range(0,1) == 0 else 1

	targetIntersection = intersectionsGrid[currRow][currCol]
	var angleTo = (targetIntersection.global_position-global_position).angle()
	rotation = int(angleTo/(PI/2)) * PI/2 + PI/2
	moveVector = Vector2(moveSpeed, 0).rotated(rotation-PI/2)
	ignoreArea = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += moveVector * delta
	if (global_position - targetIntersection.global_position).length() < .5:
		global_position = targetIntersection.global_position
		pickNextIntersection()