extends SpringArm3D

@export var mouse_sensitivity: float = 0.0001

@export var max_zoom: float = 5.0
@export var min_zoom: float = 0.5

@export_range(-90.0, 0.0, 0.1, "radians_as_degrees")
var min_vertical_angle: float = -PI / 2

@export_range(0.0, 90.0, 0.1, "radians_as_degrees")
var max_vertical_angle: float = PI / 4

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Horizontal look (yaw)
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.y = wrapf(rotation.y, 0.0, TAU)

		# Vertical look (pitch)
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)

		#  Lock camera roll (no tilt)
		rotation.z = 0.0

	# Zoom in
	if event.is_action_pressed("ZoomIn"):
		spring_length = max(spring_length - 1.0, min_zoom)

	# Zoom out
	if event.is_action_pressed("ZoomOut"):
		spring_length = min(spring_length + 1.0, max_zoom)
		
		
		#extends SpringArm3D
#
#@export var mouse_sensitivity: float = 0.005
#@export var maxZoom: float = 10.0
#@export var minZoom: float = 0.5
#@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = -PI/2
#@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vertical_angle: float = PI/4
#
#
#func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rotation.y -= event.relative.x * mouse_sensitivity
		#rotation.y = wrapf(rotation.y, 0.0, TAU)
		#rotation.x -= event.relative.y * mouse_sensitivity
		#rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
#
	#if event.is_action_pressed("ZoomIn"):
		#if spring_length > minZoom:
			#spring_length -= 1
	#if event.is_action_pressed("ZoomOut"):
		#if spring_length < maxZoom:
			#spring_length += 1
#
#
#func _process(delta: float) -> void:
#
	#pass
