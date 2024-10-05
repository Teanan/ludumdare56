extends Control

@onready var btn_play = $MarginContainer/Control/VBoxContainer/PlayButton
@onready var btn_exit = $MarginContainer/Control/VBoxContainer/ExitButton

# Set to true to avoid clicking on play every time
const AUTOPLAY = false

func _ready():
	# needed for gamepads to work
	btn_play.grab_focus()
	if OS.has_feature('web'):
		btn_exit.queue_free() # exit button dosn't make sense on HTML5
	if OS.is_debug_build():
		OS.open_midi_inputs()
        if AUTOPLAY:
            _on_PlayButton_pressed()


func _on_PlayButton_pressed() -> void:
	var params = {
		"show_progress_bar": true,
		"level_name": "Test1"
	}
	Game.change_scene_to_file("res://scenes/gameplay/gameplay.tscn", params)


func _on_ExitButton_pressed() -> void:
	# gently shutdown the game
	var transitions = get_node_or_null("/root/Transitions")
	if transitions:
		transitions.fade_in({
			'show_progress_bar': false
		})
		await transitions.anim.animation_finished
		await get_tree().create_timer(0.3).timeout
	get_tree().quit()
