extends Control

func _ready() -> void:
	OpenMainMenu()

func OpenEmails():
	$"Top performing Employees".visible = false
	$Emails.visible = true
	$MainMenu.visible = false
	
func OpenScores():
	$"Top performing Employees".visible = true
	$Emails.visible = false
	$MainMenu.visible = false
	
func OpenMainMenu():
	$"Top performing Employees".visible = false
	$Emails.visible = false
	$MainMenu.visible = true
