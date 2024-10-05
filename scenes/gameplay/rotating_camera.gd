extends Marker3D

var distance : float
var height : float
var zoom : float = 0
@onready var camera = %Camera

var angle_rad: float = 0
var camera_speed = 7
var zoom_speed = 0.1
var dragging : bool = false
var camera_velocity : Vector2 = Vector2.ZERO

# Vector3 for zoom level uses only y (height) and z(distance)
# Intermediate zoom levels are interpolated
const MIN_ZOOM = Vector3(0, 88, 110) # global view of everything
const MAX_ZOOM = Vector3(0, 13, 38) # very close to the building

func _ready() -> void:
	var zoom_pos = MIN_ZOOM.lerp(MAX_ZOOM, zoom)
	height = zoom_pos.y
	distance = zoom_pos.z
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
		camera_velocity += event.relative / 1000.0

func _process(delta: float) -> void:
	camera.look_at(self.position)
	zoom = clampf(zoom, 0.0, 1.0) 
	var zoom_pos = MIN_ZOOM.lerp(MAX_ZOOM, zoom)
	height = zoom_pos.y
	distance = zoom_pos.z
	camera.position.y = lerpf(camera.position.y, height, delta * camera_speed)
	camera.position.z = lerpf(camera.position.z, distance, delta * camera_speed)
	angle_rad -= camera_velocity.x
	var rot = self.rotation
	rot.y = lerpf(rot.y, angle_rad, delta * camera_speed)
	self.rotation = rot
	camera_velocity = camera_velocity.lerp(Vector2.ZERO, delta * camera_speed)	
