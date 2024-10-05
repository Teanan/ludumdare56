extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

@onready var mesh: MeshInstance3D = $"RigidBody3D/Basic"
@onready var body: RigidBody3D = $"RigidBody3D"

func highlight(selected: bool) -> void:
	if selected:
		mesh.scale = Vector3(1.1, 1.1, 1.1)
	else:
		mesh.scale = Vector3(1, 1, 1)

func start_snacking() -> void:
	$SnackingTimer.start()
	$SnackingParticles.visible = true
	$RigidBody3D.apply_impulse(Vector3(0, 0, 0))

func _on_snaking_timer_timeout() -> void:
	$RigidBody3D.apply_impulse(Vector3(0, 0, 0))
	queue_free()
