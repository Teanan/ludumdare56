extends CenterContainer

@export var type: CreatureEnum.CreatureType = CreatureEnum.CreatureType.CLASSIC

signal creature_selected(type: CreatureEnum.CreatureType)

func _ready() -> void:
	match type:
		CreatureEnum.CreatureType.CLASSIC:
			$CreatureSprite.self_modulate = Color("#d2d2d2")
		CreatureEnum.CreatureType.FIRE:
			$CreatureSprite.self_modulate = Color("#f6682e")
		CreatureEnum.CreatureType.WATER:
			$CreatureSprite.self_modulate = Color("#6290db")

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released() and  event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			emit_signal("creature_selected", type)

func _on_mouse_entered() -> void:
	$BottleSprite.scale = Vector2(0.6, 0.6)
	$CreatureSprite.scale = Vector2(0.6, 0.6)

func _on_mouse_exited() -> void:
	$BottleSprite.scale = Vector2(0.5, 0.5)
	$CreatureSprite.scale = Vector2(0.5, 0.5)
