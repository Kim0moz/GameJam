extends RichTextLabel
class_name  DeliveryConfirmationText

@export var deliveryMessages : Array = ["GREAT", "NICE", "OK", "PHEW"]
var deliveryMessage = "GREAT!"
@export var fadeDuration := 2.0
var fadeDT := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fadeDT += delta
	# TimeLabel.modulate.a = 0 if (int(flashingDT * 10) % 6 < 3) else 1
	modulate.a = max(0, 1 - (fadeDT/fadeDuration))
	if modulate.a == 0:
		queue_free()

func setTextIndex(textIndex : int):
	text = "[outline_color=red][center][color=white][outline_size=10
][wave amp=75.0 freq=2.05 connected=1]%s[/wave][/outline_size][/color][/center][/outline_color]" % [deliveryMessages[textIndex]]