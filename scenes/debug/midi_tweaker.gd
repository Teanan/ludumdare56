extends Node

signal midi_tweak(number, value)

var midi_map = {}
var midi_count = 1

func _input(event):
	if event is InputEventMIDI:
		var value = event.controller_value
		var number = event.controller_number
		
		if number not in midi_map:
			midi_map[number] = midi_count
			midi_count += 1
		
		var assigned_number = midi_map[number]
		
		midi_tweak.emit(assigned_number, value)
		
# Example usage after connecting signal
#	func _on_midi_tweaker_midi_tweak(number: Variant, value: Variant) -> void:
#		match number:
#			1: height = value
#			2: distance = value
#			3: print("height: ", height, " distance: ", distance)
