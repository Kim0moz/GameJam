extends Node

@export var HoverText : String = ""
@export var HoverSubText : String = ""

func display():
	InfoPopUp.Text = "[p]"+ HoverText + "[/p][p] " + HoverSubText + "[/p]"

func hide():
	InfoPopUp.HideText()
