extends Node

@onready var block_map: Node3D = $"." # where blocks are spawned
@onready var creature_map: Node3D = $"." # where creatures are spawned

# `pre_start()` is called when a scene is loaded.
# Use this function to receive params from `Game.change_scene(params)`.
func pre_start(params):
	var cur_scene: Node = get_tree().current_scene
	print("Scene loaded: ", cur_scene.name, " (", cur_scene.scene_file_path, ")")
	if params:
		for key in params:
			var val = params[key]
			printt("", key, val)

	var level = load("res://scenes/levels/" + params["level_name"] + ".tscn")
	var level_i: Node3D = level.instantiate()
	add_child.call_deferred(level_i)
	level_i.connect("tree_entered", _on_level_grid_loaded.bind(level_i))

func _on_level_grid_loaded(level: Node3D) -> void:
	var grid = level.get_node("GridMap")
	var cells = grid.get_used_cells()
	for pos in cells:
		var cell_type = grid.get_cell_item(pos)
		
		var tile_name = grid.mesh_library.get_item_name(cell_type)
		
		var type = load("res://scenes/gameplay/element/block/" + tile_name + ".tscn")
		if type == null:
			push_error("invalid tile name \"" + tile_name + "\"")
			continue

		var instance: Node3D = type.instantiate()
		block_map.add_child.call_deferred(instance)
		instance.position = Vector3(pos) * grid.cell_size + grid.position

	grid.queue_free()


# `start()` is called after pre_start and after the graphic transition ends.
func start():
	print("gameplay.gd: start() called")

	var creature: Resource = load("res://scenes/creatures/creatures.tscn")

	var creature_instance_classic: Node3D = creature.instantiate()
	creature_instance_classic.type = creature_instance_classic.CreatureType.CLASSIC
	creature_map.add_child.call_deferred(creature_instance_classic)
	creature_instance_classic.position = Vector3(0,0,20)

	var creature_instance_fire: Node3D = creature.instantiate()
	creature_instance_fire.type = creature_instance_fire.CreatureType.FIRE
	creature_map.add_child.call_deferred(creature_instance_fire)
	creature_instance_fire.position = Vector3(10,0,20)	

	var creature_instance_water: Node3D = creature.instantiate()
	creature_instance_water.type = creature_instance_water.CreatureType.WATER
	creature_map.add_child.call_deferred(creature_instance_water)
	creature_instance_water.position = Vector3(20,0,20)
