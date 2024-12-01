extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = get_children()
	var hs = GlobalVariables.highScores
	for i in range(children.size()):
		var item = children[i]
		var hsi = hs[i]
		(item as EmployeePanel).updatePanel(hsi.Score,hsi.Employee,hsi.Icon,str(int(item.name)+1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
