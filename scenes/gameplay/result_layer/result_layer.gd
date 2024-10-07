extends CanvasLayer


var current_level: int


func _ready() -> void:
	result_hide()


func victory_show() -> void:
	result_show()


func defeat_show() -> void:
	result_show()


func result_show() -> void:
	$ColorRect.visible = true
	$MarginContainer.visible = true
	$MarginContainer/Control/VBoxOptions.grab_focus()


func result_hide() -> void:
	$ColorRect.visible = false
	$MarginContainer.visible = false


func _on_next_pressed() -> void:
	print("next level")
	var params = {
		"show_progress_bar": true,
		"level_name": "Level" + str(current_level + 1)
	}
	Game.change_scene_to_file("res://scenes/gameplay/gameplay.tscn", params)


func _on_retry_pressed() -> void:
	print("retry level")
	var params = {
		"show_progress_bar": true,
		"level_name": "Level" + str(current_level)
	}
	Game.change_scene_to_file("res://scenes/gameplay/gameplay.tscn", params)


func _on_main_menu_pressed() -> void:
	print("back 2 menu")
	Game.change_scene_to_file("res://scenes/menu/menu.tscn", {"show_progress_bar": false})
