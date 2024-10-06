extends RigidBody3D

@onready var com_marker = $CenterOfMass

@export var mesh: MeshInstance3D

func _ready() -> void:
	self.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	self.center_of_mass = com_marker.position

func highlight(selected: bool) -> void:
	if selected:
		mesh.scale = Vector3(4.4, 4.4, 4.4)
	else:
		mesh.scale = Vector3(4, 4, 4)
