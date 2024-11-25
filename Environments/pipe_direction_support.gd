@tool
extends Node3D
class_name PipeSupport

@export var outlets : Array = [[Vector3i(0,0,0),Vector3i(0,0,0)]]
@onready var Grid : GridMap = self.get_parent()

func activeDirections(pipe : int, cellRotation):
	var list = []
	for outlet in outlets[pipe]:
		list.append(rotateToOrientation(outlet,cellRotation) as Vector3i)
	return list

func rotateToOrientation(pos : Vector3, cellRotation):
	var oris = [
		Vector3(0,0,1),
		Vector3(0,1,0),
		Vector3(0,0,-1),
		Vector3(0,-1,0),
		Vector3(-1,0,0),
		Vector3(1,0,0)
		]
	var flooredVal : float = floor(cellRotation/4)
	var modVal : float = (cellRotation%4)
	var firstRot = ((flooredVal)/4)*360
	var secondRot = (modVal/4)*360

	var FirstRot = pos.rotated(oris[flooredVal],deg_to_rad(secondRot))
	var FinalRot 
	if cellRotation >= 16 and cellRotation < 20:
		FinalRot = FirstRot.rotated(Vector3(0,1,0),deg_to_rad(90))
	elif cellRotation >= 20:
		FinalRot = FirstRot.rotated(Vector3(0,1,0),deg_to_rad(90))
		FinalRot = FinalRot.rotated(Vector3(1,0,0),deg_to_rad(180))
	else:
		FinalRot = FirstRot.rotated(Vector3(1,0,0),deg_to_rad(firstRot))
	return FinalRot as Vector3i
	
	
