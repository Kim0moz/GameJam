extends PanelContainer
class_name EmployeePanel

@onready var score = $HBoxContainer/Score/MarginContainer/Score
@onready var id = $HBoxContainer/Panel/HBoxContainer/ID
@onready var picture = $HBoxContainer/Panel/HBoxContainer/Panel/TextureRect
@onready var ranking = $HBoxContainer/Ranking/Ranking


func updatePanel(_score,_id,_picture,_ranking):
	ranking.text = str(_ranking)
	picture.texture.region = Rect2(0,(_picture*16),16,16)
	score.text = str(_score)
	id.text = "Employee #" + _id
