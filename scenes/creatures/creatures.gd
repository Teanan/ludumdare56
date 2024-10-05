extends Node3D

enum CreatureType {
	CLASSIC,
	FIRE,
	WATER
}

@export var type: CreatureType = CreatureType.CLASSIC

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


func _process(_delta: float) -> void:
	pass
