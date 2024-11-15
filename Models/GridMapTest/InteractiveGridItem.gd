extends Node
class_name InteractiveGridItem

@export var Data : Dictionary

signal initialized

func initializeItem(_data : Dictionary):
	Data = Data
	initialized.emit()
