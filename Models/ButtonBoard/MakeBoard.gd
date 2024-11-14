@tool
extends Node3D

@export var button : PackedScene
@export var buttons : Node3D
@export var GenerateButtonData :bool :
	set(val):
		generateButtonData()
@export var buttonData : Array[Dictionary] = [{"transform": Vector3(0,0,0), "rotations": [11,15,3,07]}]
@export var grid : GridMap
@export var correctAnswer : Array[Dictionary]

@export_category("Padding")
@export_group("Start")
@export var yMinMax : Vector2
@export var xMinMax : Vector2
@export_group("End")
@export var yOffsetMinMax : Vector2
@export var xOffsetMinMax : Vector2

signal buttonsMade

func _ready() -> void:
	generateButtonData()

func generateButtonData():
	var items = grid.get_used_cells_by_item(6)
	buttonData.clear()
	for item in items:
		buttonData.append({
			"transform": item,
			"rotations": [11,15,3,07]})
	build_grid()
	

func _add_data(amount: int):
	buttonData.clear()
	for i in range(amount):
		buttonData.append({"transform": Vector3(0,0,0), "rotations": [11,15,3,07]})
		
func setCorrectAnswer():
	var i = 0
	correctAnswer.clear()
	for button in buttons.get_children():
		correctAnswer.push_back({"transform": Vector3(0,0,0), "rotation": 0})
		correctAnswer[i].transform = (button as pipeLever).PipeIndex
		correctAnswer[i].rotation = (button as pipeLever).rots[(button as pipeLever).index]
		i+=1

func  _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("movement_jump"):
			#setCorrectAnswer()
			print(checkAnswer())

func build_grid():
	var index = 0
	if buttons:
		for butts in buttons.get_children():
			butts.free()
	for butt in buttonData:
		if butt.transform != Vector3i.ZERO:
			var tmp : pipeLever = button.instantiate()
			buttons.add_child(tmp,true)
			tmp.name = str(buttons.get_child_count())
			tmp.set_owner(self)
			tmp.grid = grid
			tmp.rots = butt.rotations 
			tmp.PipeIndex = butt.transform
			var tx = remap(butt.transform.z,yMinMax.x,yMinMax.y,yOffsetMinMax.x,yOffsetMinMax.y)
			var tz = remap(butt.transform.x,xMinMax.x,xMinMax.y,xOffsetMinMax.x,xOffsetMinMax.y)
			tmp.position = Vector3(.2,tz,tx)
	buttonsMade.emit()
		
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
