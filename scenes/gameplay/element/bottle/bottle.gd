extends Node3D

signal broken(start_pos: Vector3, type: CreatureEnum.CreatureType, targets: Array[Node3D])

var type: CreatureEnum.CreatureType
var targets: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("bottle entered: " + body.name)
	if body.name == "Ground":
		$WaterParticles.emitting = true
		$Mesh.visible = false
		broken.emit(global_position, type, targets)


func _on_water_particles_finished() -> void:
	print("bottle done")
	self.queue_free()
