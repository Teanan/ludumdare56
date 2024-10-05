extends Node

@onready var block_map: Node3D = $"Blocks" # where blocks are spawned
@onready var creature_map: Node3D = $"Creatures" # where creatures are spawned
@onready var camera = $"RotatingCamera/Camera"

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
		var cell_basis =  grid.get_cell_item_basis(pos)

		var tile_name = grid.mesh_library.get_item_name(cell_type)
		
		var type = load("res://scenes/gameplay/element/block/" + tile_name + ".tscn")
		if type == null:
			push_error("invalid tile name \"" + tile_name + "\"")
			continue

		var instance: Node3D = type.instantiate()
		block_map.add_child.call_deferred(instance)
		instance.position = Vector3(pos) * grid.cell_size + grid.position
		instance.rotation = cell_basis.get_euler()

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


var selected_block: Node3D = null

func _physics_process(_delta: float) -> void:
	if not camera:
		return

	var viewport = get_viewport()
	var m_pos = viewport.get_mouse_position()
	var ray_start = camera.project_ray_origin(m_pos)
	var ray_end = ray_start + camera.project_ray_normal(m_pos) * 1000
	var world3d : World3D = viewport.world_3d
	var space_state = world3d.direct_space_state
	
	if space_state == null:
		return
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)#, collision_mask)
	query.collide_with_areas = true
	
	var intersect = space_state.intersect_ray(query)
	if "collider" in intersect and intersect["collider"].is_in_group("targetable"):
		var block_node = intersect["collider"].get_parent()
		if selected_block != block_node:
			if selected_block != null:
				selected_block.highlight(false)
			selected_block = block_node
			selected_block.highlight(true)
	elif selected_block != null:
		selected_block.highlight(false)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_released() && event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if selected_block != null:
				for c in creature_map.get_children():
					c.targets.append(selected_block)
