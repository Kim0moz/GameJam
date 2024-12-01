extends Control

@export var Text : String = "":
	set(val):
		Text = val
		DisplayText()
@onready var Display = $PanelContainer/Label

func _ready() -> void:
	HideText()

func DisplayText():
	self.visible = true
	Display.text = Text


func HideText():
	self.visible = false
