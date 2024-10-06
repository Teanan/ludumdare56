extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SnackingParticles.visible = false

func start_snacking() -> void:
	$SnackingTimer.start()
	$SnackingParticles.visible = true

func _on_snacking_timer_timeout() -> void:
	get_parent().sleeping = false
	get_parent().apply_impulse(Vector3(0, 0, 0))
	get_parent().queue_free()
