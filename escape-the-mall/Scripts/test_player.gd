extends CharacterBody3D

@onready var camera_mount: Node3D = $cameraMount

const SPEED = 5.0
const JUMP_VELOCITY = 6.5

var sensHorizontal = 0.5
var sensVertical = 0.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensHorizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sensVertical))
		camera_mount.rotation.x = clamp(
			camera_mount.rotation.x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var input_dir = Input.get_vector(
		"MoveLeft",
		"MoveRight",
		"MoveForward",
		"MoveBackwards"
	)

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
