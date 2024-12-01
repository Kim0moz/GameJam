extends RichTextLabel
class_name  DeliveryConfirmationText

@export var deliveryMessages : Array = ["GREAT", "NICE", "OK", "PHEW"]
var deliveryMessage = "GREAT!"
@export var fadeDuration := 2.0
var fadeDT := 0.0
## If turned on, wave text effect will be disabled
@export var useFlashingColors := false
@export var flashColorName1 := "red"
@export var flashColorName2 := "green"
## Lower number results in faster flashing
@export var flashRate : int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fadeDT += delta
	if useFlashingColors:
		text = text.replace(flashColorName1, flashColorName2) if (int(fadeDT * 10) % flashRate < flashRate/2) else text.replace(flashColorName2, flashColorName1)
	modulate.a = max(0, 1 - (fadeDT/fadeDuration))
	if modulate.a == 0:
		queue_free()

func setTextIndex(textIndex : int):
	if useFlashingColors:
		text = "[outline_color=red][center][color=white][outline_size=10
]%s[/outline_size][/color][/center][/outline_color]" % [deliveryMessages[textIndex]]
	else:
		text = "[outline_color=red][center][color=white][outline_size=10
][wave amp=75.0 freq=2.0 connected=1]%s[/wave][/outline_size][/color][/center][/outline_color]" % [deliveryMessages[textIndex]]

func setCustomMessage(message : String):
	text = "[outline_color=red][center][color=white][outline_size=10
]%s[/outline_size][/color][/center][/outline_color]" % message