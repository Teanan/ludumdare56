extends Node

@onready var block_map: Node3D = $"Blocks" # where blocks are spawned
@onready var creature_map: Node3D = $"Creatures" # where creatures are spawned
@onready var camera = $"RotatingCamera/Camera"

var level_center: Vector3

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
	level_center = level.global_position
	grid.queue_free()


# `start()` is called after pre_start and after the graphic transition ends.
func start():
	print("gameplay.gd: start() called")


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


func find_start_spawn(local_selected_block: Node3D) -> Vector3:
	var spawn_pos = level_center.direction_to(local_selected_block.body.global_position) * 50
	return spawn_pos


func spawn_bottle(type: CreatureEnum.CreatureType, local_selected_block: Node3D) -> void:
	var bottle: Resource = load("res://scenes/gameplay/element/bottle/bottle.tscn")
	var bottle_instance: Node3D = bottle.instantiate()
	bottle_instance.position = find_start_spawn(selected_block)
	bottle_instance.type = type
	bottle_instance.targets.append(local_selected_block)
	bottle_instance.connect("broken", _on_bottle_break)
	creature_map.add_child.call_deferred(bottle_instance)


func spawn_creature_at_pos_with_targets(pos: Vector3, type: CreatureEnum.CreatureType, targets: Array[Node3D]) -> void:
	var creature: Resource = load("res://scenes/creatures/creatures.tscn")

	var creature_instance: Node3D = creature.instantiate()
	creature_instance.type = type
	creature_instance.position = pos
	creature_instance.targets = targets
	creature_map.add_child.call_deferred(creature_instance)


func _on_bottle_break(pos: Vector3, type: CreatureEnum.CreatureType, targets: Array[Node3D]) -> void:
	print("spawn at ", pos)
	spawn_creature_at_pos_with_targets(pos, type, targets)


var current_type: CreatureEnum.CreatureType = CreatureEnum.CreatureType.CLASSIC

func _input(event):
	if event is InputEventMouseButton:
		if event.is_released() && event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if selected_block != null:
				spawn_bottle(current_type, selected_block)
				current_type = ((current_type + 1) % CreatureEnum.CreatureType.size()) as CreatureEnum.CreatureType
