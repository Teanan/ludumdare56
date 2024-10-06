extends CanvasLayer

signal creature_selected(type: CreatureEnum.CreatureType)

var type: CreatureEnum.CreatureType = CreatureEnum.CreatureType.None

func clear():
	type = CreatureEnum.CreatureType.None
	$Cursor.visible = false

func _on_panel_creature_selected(s_type: CreatureEnum.CreatureType) -> void:
	creature_selected.emit(s_type)
	type = s_type

	$Cursor.visible = false
	match type:
		CreatureEnum.CreatureType.CLASSIC:
			$Cursor/CreatureSprite.self_modulate = Color("#d2d2d2")
		CreatureEnum.CreatureType.FIRE:
			$Cursor/CreatureSprite.self_modulate = Color("#f6682e")
		CreatureEnum.CreatureType.WATER:
			$Cursor/CreatureSprite.self_modulate = Color("#6290db")


func _on_margin_container_gui_input(event: InputEvent) -> void:
	if type != CreatureEnum.CreatureType.None:
		$Cursor.visible = true
		if event is InputEventMouseMotion:
			$Cursor.position = event.position
