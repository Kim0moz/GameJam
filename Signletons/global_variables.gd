extends Node

var player : Player

var highScores : Array[Dictionary] = [{"Employee": "ID", "Score": 0, "Icon" : 0}]

func _ready() -> void:
	generateHighscores()

func generateHighscores():
	highScores.clear()
	for i in range(20):
		var id = randi_range(0,5000)
		while id == 4904:
			id = randi_range(0,5000)
		var idString = ("%04d" % id) 
		var icon = randi_range(0,3)
		var scoreMod = 600+((20-i)*30)
		var highEnd = 600+((20-i-1)*30)
		var score = randi_range(scoreMod,highEnd)
		
		highScores.append({"Employee": idString, "Score": str(score), "Icon" : icon})
	print(highScores)
		
func insertHighscore(score : int,):
	for i in range(highScores.size()):
		if highScores[i].Score < score:
			highScores.append({"Employee": "4904", "Score": score, "Icon" : randi_range(0,3)})
			highScores.pop_back()
			return
