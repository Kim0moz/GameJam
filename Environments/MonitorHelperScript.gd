@tool
extends MeshInstance3D

@export var VP : SubViewport

func _ready() -> void:
	self.get_surface_override_material(1).albedo_texture = VP.get_texture()
