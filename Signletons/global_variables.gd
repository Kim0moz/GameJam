extends Node

var player : Player

var highScores : Array[Dictionary] = [{"Employee": "ID", "Score": 0, "Icon" : 0}]

func _ready() -> void:
	generateHighscores()

func generateHighscores():
	highScores.clear()
	for i in range(20):
		var id = randi_range(0,5000)
		var idString = ("%04d" % id) 
		var icon = id%4
		var scoreMod = (20-i)*60
		var highEnd = (20-i-1)*60
		var score = randi_range(scoreMod,highEnd)
		
		highScores.append({"Employee": idString, "Score": str(score), "Icon" : icon})
	print(highScores)
		
