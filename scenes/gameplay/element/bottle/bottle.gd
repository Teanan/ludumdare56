extends Node3D

signal broken(start_pos: Vector3, targets: Array[Node3D])

var start_pos: Vector3
var targets: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("bottle entered: " + body.name)
	if body.name == "Ground":
		$RigidBody3D/WaterParticles.emitting = true
		$RigidBody3D/Mesh.visible = false
		broken.emit(start_pos,targets)


func _on_water_particles_finished() -> void:
	print("bottle done")
	self.queue_free()
