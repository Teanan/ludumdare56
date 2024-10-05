extends Marker3D

var distance : float = 150.0
var height : float = 100.0
var zoom : float = 0.1
@onready var camera = %Camera

var angle_rad: float = 0
var camera_speed = 5
var zoom_speed = 0.5
var dragging : bool = false
var camera_velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	camera.position.y = height
	camera.position.z = distance
	camera.look_at(self.position)


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
				dragging = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				dragging = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
				zoom += zoom_speed
			
			if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
				zoom -= zoom_speed
			
		else:
			dragging = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	elif event is InputEventMouseMotion and dragging:
		print(event.relative)
		camera_velocity += event.relative / 1000.0

func _process(delta: float) -> void:
	#zoom += 5 * delta
	zoom = clampf(zoom, 0.1, 5.0)
	height = 20 / zoom - 3
	distance = 30 / zoom
	camera.position.y = lerpf(camera.position.y, height, delta * camera_speed)
	camera.position.z = lerpf(camera.position.z, distance, delta * camera_speed)
	angle_rad -= camera_velocity.x
	var rot = self.rotation
	rot.y = lerpf(rot.y, angle_rad, delta * camera_speed)
	self.rotation = rot
	camera_velocity = camera_velocity.lerp(Vector2.ZERO, delta * camera_speed)
	
	
