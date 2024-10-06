extends Node3D

@export var type: CreatureEnum.CreatureType = CreatureEnum.CreatureType.CLASSIC
@export var speed: float = 8.0
@export var targets: Array[Node3D]

var state: CreatureEnum.CreatureState = CreatureEnum.CreatureState.IDLING

var current_target_selected: bool = false
var current_target: Node3D

var escape_pos: Vector3

func _ready() -> void:
	var local_dust_mesh: SphereMesh = $dust.mesh.duplicate()
	var local_dust_mat: StandardMaterial3D = local_dust_mesh.material.duplicate()

	match type:
		CreatureEnum.CreatureType.CLASSIC:
			local_dust_mat.albedo_color = Color("#d2d2d2")
		CreatureEnum.CreatureType.FIRE:
			local_dust_mat.albedo_color = Color("#f6682e")
		CreatureEnum.CreatureType.WATER:
			local_dust_mat.albedo_color = Color("#6290db")

	local_dust_mesh.material = local_dust_mat
	$dust.mesh = local_dust_mesh
	escape_pos = global_position
	state = CreatureEnum.CreatureState.LOOKING_FOR_SNACK


func get_snack_time(block_type: BlockEnum.BlockType) -> float:
	return 5.0


func start_snacking() -> void:
	var snack_time = get_snack_time(current_target.type)
	$snack_timer.wait_time = snack_time + 0.5
	$snack_timer.start()
	current_target.start_snacking(snack_time)
	current_target_selected = false
	state = CreatureEnum.CreatureState.SNACKING


func _on_snack_timer_timeout() -> void:
	if state == CreatureEnum.CreatureState.SNACKING:
		state = CreatureEnum.CreatureState.ESCAPING
	else:
		print("undefined state")
		state = CreatureEnum.CreatureState.IDLING


func look_4_snack(delta: float) -> void:
	if current_target_selected == false:
		if targets.is_empty():
			pass
		else:
			current_target = targets.pop_front()
			current_target_selected = true
			
	if current_target == null:
		# target destroy before we arrived
		current_target_selected = false
		state = CreatureEnum.CreatureState.IDLING

	if current_target_selected:
		if position.distance_to(current_target.global_position) > 1.0:
			position = position.move_toward(current_target.global_position, delta*speed)
		else:
			start_snacking()

func escape(delta: float) -> void:
	if position.distance_to(escape_pos) > 1.0:
		position = position.move_toward(escape_pos, delta*speed)
	else:
		print("escaped")
		self.queue_free()

func _process(delta: float) -> void:
	match state:
		CreatureEnum.CreatureState.LOOKING_FOR_SNACK:
			look_4_snack(delta)
		CreatureEnum.CreatureState.SNACKING:
			pass
		CreatureEnum.CreatureState.ESCAPING:
			escape(delta)
		CreatureEnum.CreatureState.IDLING:
			pass
