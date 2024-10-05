extends Node3D

enum CreatureType {
	CLASSIC,
	FIRE,
	WATER
}

@export var type: CreatureType = CreatureType.CLASSIC
@export var speed: float = 2.0
@export var targets: Array[Vector3]

var current_target_selected: bool = false
var current_target: Vector3

func _ready() -> void:
	var local_dust_mesh: SphereMesh = $dust.mesh.duplicate()
	var local_dust_mat: StandardMaterial3D = local_dust_mesh.material.duplicate()

	match type:
		CreatureType.CLASSIC:
			local_dust_mat.albedo_color = Color("#d2d2d2")
		CreatureType.FIRE:
			local_dust_mat.albedo_color = Color("#f6682e")
		CreatureType.WATER:
			local_dust_mat.albedo_color = Color("#6290db")

	local_dust_mesh.material = local_dust_mat
	$dust.mesh = local_dust_mesh


func _process(delta: float) -> void:
	if current_target_selected == false:
		if targets.is_empty():
			pass
		else:
			current_target = targets.pop_front()
			current_target_selected = true

	if current_target_selected:
		if position.distance_to(current_target) > 1.0:
			position = position.move_toward(current_target, delta*speed)
		else:
			current_target_selected = false
			print("done")
	
