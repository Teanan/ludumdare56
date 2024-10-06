extends RigidBody3D


@export var type: CreatureEnum.MainCharType


func _ready() -> void:
	pass
	#var local_mesh: Mesh = $MeshInstance3D.mesh.duplicate()
	#var local_mat: StandardMaterial3D = local_mesh.surface_get_material(0).duplicate()
	#local_mesh.surface_set_material(0, local_mat)
	#$MeshInstance3D.mesh = local_mesh
	
	#local_mat.albedo_color = Color("#963d34")
	#local_mat.blend_mode = BaseMaterial3D.BLEND_MODE_MUL


func _process(_delta: float) -> void:
	pass


func _on_area_3d_body_entered(_body: Node3D) -> void:
	$DeathParticles.emitting = true

	var free_timer = Timer.new()
	free_timer.set_wait_time(2) # 5 seconds wait time
	free_timer.set_one_shot(true)
	add_child(free_timer)
	free_timer.start()
	free_timer.connect("timeout", queue_free)
	#var tween = create_tween()
	#tween.tween_property($MeshInstance3D.mesh.surface_get_material(0), "modulate:a", 0, 5.0)
	#tween.tween_property($MeshInstance3D2.mesh.surface_get_material(0), "modulate:a", 0, 5.0)
