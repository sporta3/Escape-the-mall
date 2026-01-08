extends CharacterBody3D

@onready var camera_mount: Node3D = $cameraMount

# The values for walkin, sprinting, jumping height, gravity, fall multiplier and run aceleration (should be self explanitory)
# We could export these values so we can edit them in the Main doesnt have to be neccecairy 
const WALK_SPEED := 5.0
const SPRINT_SPEED := 10.0
const JUMP_VELOCITY := 8.0
const GRAVITY := 30.0
const FALL_MULTIPLIER := 1.8
const ACCELERATION := 5.0

# Mouse sensitivity
var sens_horizontal := 0.5
var sens_vertical := 0.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		#camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		#camera_mount.rotation.x = clamp(
			#camera_mount.rotation.x,
			#deg_to_rad(-89),
			#deg_to_rad(89)
		#)

func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y -= GRAVITY * delta
		else:
			velocity.y -= GRAVITY * FALL_MULTIPLIER * delta


	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("Jump") and velocity.y > 0:
		velocity.y *= 0.5

	# Sprint
	var target_speed := WALK_SPEED
	if Input.is_action_pressed("Sprint"):
		target_speed = SPRINT_SPEED


	# Movement
	var input_dir := Input.get_vector(
		"MoveLeft",
		"MoveRight",
		"MoveForward",
		"MoveBackwards"
	)

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * target_speed, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * target_speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION)

	move_and_slide()
