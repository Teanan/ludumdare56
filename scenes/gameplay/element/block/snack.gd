extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SnackingParticles.mesh = get_parent().mesh.mesh
	$SnackingParticles.material_override = get_parent().mesh.get_surface_override_material(0)

func start_snacking(snack_time: float) -> void:
	$SnackingTimer.wait_time = snack_time
	$SnackingTimer.start()
	$SnackingParticles.lifetime = snack_time - 0.5
	$SnackingParticles.emitting = true

func _on_snacking_timer_timeout() -> void:
	get_parent().sleeping = false
	get_parent().apply_impulse(Vector3(0, 0, 0))
	get_parent().queue_free()
