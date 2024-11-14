@tool
extends Node3D

@export var button : PackedScene
@export var buttons : Node3D
@export var buttonData : Array[Dictionary] = [{"transform": Vector3(0,0,0), "rotations": [11,15,3,07]}]
@export var grid : GridMap
@export var columns : int = 4

@export var yOffset : float = 0:
	set(val):
		yOffset = val
		build_grid()
@export var zOffset : float = 0:
	set(val):
		zOffset = val
		build_grid()
@export var zPadding : float = 0:
	set(val):
		zPadding = val
		build_grid()
@export var yPadding : float = 0:
	set(val):
		yPadding = val
		build_grid()
		
@export var correctAnswer : Array[Dictionary]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_add_data(16)
	build_grid()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_data(amount: int):
	buttonData.clear()
	for i in range(amount):
		buttonData.append({"transform": Vector3(0,0,0), "rotations": [11,15,3,07]})
		
func setCorrectAnswer():
	var i = 0
	for button in buttons.get_children():
		correctAnswer.push_back({"transform": Vector3(0,0,0), "rotation": 0})
		correctAnswer[i].transform = (button as pipeLever).PipeIndex
		correctAnswer[i].rotation = (button as pipeLever).rots[(button as pipeLever).index]
		i+=1

func  _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("movement_jump"):
			print(checkAnswer())

func build_grid():
	var index = 0
	if buttons:
		for butts in buttons.get_children():
			butts.free()
	for butt in buttonData:
		if butt.transform != Vector3.ZERO:
			var tmp : pipeLever = button.instantiate()
			buttons.add_child(tmp,true)
			tmp.name = str(buttons.get_child_count())
			tmp.set_owner(self)
			tmp.grid = grid
			tmp.rots = butt.rotations 
			tmp.PipeIndex = butt.transform
			tmp.position = Vector3(.1,yOffset+floor(index/columns)/yPadding,zOffset+(index%columns)/zPadding)
		index+=1
		
func checkAnswer():
	var i = 0
	for button in buttons.get_children():
		var t = (button as pipeLever).PipeIndex
		var r = (button as pipeLever).rots[(button as pipeLever).index]
		var contained = checkTransform(t,r)
		if contained == false:
			return false
		i+=1
	return true

func checkTransform(t,r):
	for answer in correctAnswer:
		if t == answer.transform:
			if r == answer.rotation:
				print("correct alignment ", t)
			else:
				return false
	return true
