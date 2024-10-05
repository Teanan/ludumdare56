extends Node3D

enum CreatureType {
	CLASSIC,
	FIRE,
	WATER
}

@export var type: CreatureType = CreatureType.CLASSIC

@onready var dust_color = $dust.mesh.material.albedo_color

func _ready() -> void:
	match type:
		CreatureType.CLASSIC:
			dust_color = Color("#d2d2d2")
		CreatureType.FIRE:
			dust_color = Color("#f6682e")
		CreatureType.WATER:
			dust_color = Color("#6290db")


func _process(_delta: float) -> void:
	pass
