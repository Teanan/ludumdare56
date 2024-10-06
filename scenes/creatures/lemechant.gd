extends RigidBody3D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var local_mesh: Mesh = $MeshInstance3D.mesh.duplicate()
	#var local_mat: StandardMaterial3D = local_mesh.surface_get_material(0).duplicate()
	#local_mesh.surface_set_material(0, local_mat)
	#$MeshInstance3D.mesh = local_mesh
	
	#local_mat.albedo_color = Color("#963d34")
	#local_mat.blend_mode = BaseMaterial3D.BLEND_MODE_MUL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
