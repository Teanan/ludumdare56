extends Control

@export var level_button: PackedScene;

const MAX_LEVEL = 5

# Set to true to avoid clicking on play every time
const AUTOPLAY = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1, MAX_LEVEL + 1):
		add_Level_Button(i)

	if OS.is_debug_build():
		OS.open_midi_inputs()
		if AUTOPLAY:
			await get_tree().create_timer(0.5).timeout
			_on_Level_Button_pressed(1)

func add_Level_Button(i):
	var button = level_button.instantiate()
	button.text = "Level " + str(i)
	%LevelsGrid.add_child(button)
	button.connect("pressed", Callable(self, "_on_Level_Button_pressed").bind(i))

func _on_Level_Button_pressed(i):
	var params = {
		"show_progress_bar": true,
		"level_int": i
	}
	Game.change_scene_to_file("res://scenes/gameplay/gameplay.tscn", params)
