extends CharacterBody3D

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var animation_player: AnimationPlayer = $"Node3D/Traveler girl Animated 2/AnimationPlayer"

# --------------------
# Movement values
# --------------------
const WALK_SPEED := 5.0
const SPRINT_SPEED := 10.0
const JUMP_VELOCITY := 8.0
const GRAVITY := 30.0
const FALL_MULTIPLIER := 1.8
const ACCELERATION := 5.0

var runningAnimationSpeed:= 3.0
var walkingAnimationSpeed:= 1.5
# --------------------
# Mouse sensitivity
# --------------------
var sens_horizontal := 0.5
var sens_vertical := 0.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate player horizontally
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))

		# Rotate camera vertically (spring arm)
		spring_arm.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		spring_arm.rotation.x = clamp(
			spring_arm.rotation.x,
			deg_to_rad(-60),
			deg_to_rad(60)
		)

func _physics_process(delta: float) -> void:
	# --------------------
	# Gravity
	# --------------------
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y -= GRAVITY * delta
		else:
			velocity.y -= GRAVITY * FALL_MULTIPLIER * delta

	# --------------------
	# Jump
	# --------------------
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("Jump") and velocity.y > 0:
		velocity.y *= 0.5

	# --------------------
	# Sprint
	# --------------------
	var target_speed := WALK_SPEED
	if Input.is_action_pressed("Sprint"):
		target_speed = SPRINT_SPEED
		animation_player.speed_scale = runningAnimationSpeed

	# --------------------
	# Camera-relative movement
	# --------------------
	var input_dir := Input.get_vector(
		"MoveLeft",
		"MoveRight",
		"MoveForward",
		"MoveBackwards"
	)

	var cam_basis := spring_arm.global_transform.basis
	var forward := cam_basis.z
	var right := cam_basis.x

	# Flatten movement to ground
	forward.y = 0
	right.y = 0

	forward = forward.normalized()
	right = right.normalized()

	var direction := (right * input_dir.x + forward * input_dir.y).normalized()

	if direction:
		if animation_player.current_animation != "rigAction":
			animation_player.play("rigAction")
			animation_player.speed_scale = walkingAnimationSpeed
		velocity.x = move_toward(velocity.x, direction.x * target_speed, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * target_speed, ACCELERATION)
	else:
		
		animation_player.stop()
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION)

	move_and_slide()
