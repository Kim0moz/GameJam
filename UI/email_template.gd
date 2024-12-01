extends Control
class_name EmailTemplate

@onready var from = $Button/HBoxContainer/From/From
@onready var subject = $Button/HBoxContainer/Subject/Subject
@onready var body = $EmailBody/ScrollContainer/DeliverySoftText

	
func setVals(_from : String,_subject : String,_body : String):
	await ready
	body.text = "[font_size=40]"+_body + "[/font_size]"
	subject.text = _subject
	from.text = _from
