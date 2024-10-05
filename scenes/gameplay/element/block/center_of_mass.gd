extends RigidBody3D

@onready var com_marker = $CenterOfMass

func _ready() -> void:
	self.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	self.center_of_mass = com_marker.position
