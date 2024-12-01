extends Panel

@export var Emails : Array[Dictionary] = [{"From": "Name","Subject":"Subject","Body":"Body"},
{"From": "Name","Subject":"Subject","Body":"Body"},
{"From": "Name","Subject":"Subject","Body":"Body"},
{"From": "Name","Subject":"Subject","Body":"Body"},
{"From": "Name","Subject":"Subject","Body":"Body"},
{"From": "Name","Subject":"Subject","Body":"Body"},
{"From": "Name","Subject":"Subject","Body":"Body"}]
@export var EmailTemplate : PackedScene
@onready var c = $ScrollContainer/VBoxContainer

func _ready() -> void:
	call_deferred("clearEmails")
	call_deferred("buildEmails")

func buildEmails():
	for email in Emails:
		c.add_child(makeEmail(email),true)
	
func makeEmail(vals : Dictionary):
	var tmp : EmailTemplate = EmailTemplate.instantiate()
	tmp.setVals(vals.From,vals.Subject,vals.Body)
	tmp.name = vals.Subject
	return tmp

func clearEmails():
	for child in c.get_children():
		child.free()
