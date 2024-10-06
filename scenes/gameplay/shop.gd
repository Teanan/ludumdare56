extends CanvasLayer

signal creature_selected(type: CreatureEnum.CreatureType)

func _on_panel_creature_selected(type: CreatureEnum.CreatureType) -> void:
	emit_signal("creature_selected", type)
