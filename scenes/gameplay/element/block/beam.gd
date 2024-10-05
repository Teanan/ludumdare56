extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var mesh: MeshInstance3D = $"RigidBody3D/Beam"

func highlight(selected: bool) -> void:
	if selected:
		mesh.scale = Vector3(1.1, 1.1, 1.1)
	else:
		mesh.scale = Vector3(1, 1, 1)
