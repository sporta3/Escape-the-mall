extends CharacterBody3D
#bij player moet nog de groupe "player"toegevoegt worden
#bij de map moeten er nog patrol points toegevoegt worden

enum State { PATROL, CHASE }

@export var speed_patrol: float = 2.5
@export var speed_chase: float = 4.5
@export var lose_sight_time: float = 2.0
@export var turn_speed: float = 8.0
@export var patrol_points_path: NodePath

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var vision_area: Area3D = $VisionArea
@onready var ray: RayCast3D = $RayCast3D

var state: State = State.PATROL
var player: Node3D = null
var patrol_points: Array[Node3D] = []
var patrol_index := 0
var time_since_seen := 999.0
@export var gravity: float = 25.0

func _ready() -> void:
	vision_area.body_entered.connect(_on_vision_body_entered)
	vision_area.body_exited.connect(_on_vision_body_exited)

	agent.path_desired_distance = 0.5
	agent.target_desired_distance = 0.8

	# Alleen gebruiken als je NIET via Main set_patrol_points() aanroept
	if patrol_points_path != NodePath():
		var holder = get_node(patrol_points_path) as Node3D
		if holder:
			set_patrol_points(holder)

func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % 30 == 0:
		print("state=", state,
		" target=", agent.target_position,
			 " next=", agent.get_next_path_position(),
			" finished=", agent.is_navigation_finished(),
			" points=", patrol_points.size())


	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	if player != null and _can_see_player():
		time_since_seen = 0.0
		state = State.CHASE
	else:
		time_since_seen += delta
		if state == State.CHASE and time_since_seen > lose_sight_time:
			state = State.PATROL
			player = null
			_set_target(_current_patrol_target())
	match state:
		State.PATROL:
			_update_patrol()
			_move_along_path(delta, speed_patrol)
		State.CHASE:
			_update_chase()
			_move_along_path(delta, speed_chase)

func _update_patrol() -> void:
	if patrol_points.size() == 0:
		return

	if agent.is_navigation_finished():
		patrol_index = (patrol_index + 1) % patrol_points.size()
		_set_target(_current_patrol_target())

func _update_chase() -> void:
	if player == null:
		return
	agent.target_position = player.global_position

func _move_along_path(delta: float, speed: float) -> void:
	var next_pos: Vector3 = agent.get_next_path_position()
	var dir: Vector3 = (next_pos - global_position)
	dir.y = 0.0
#draaien
	if dir.length() > 0.01:
		dir = dir.normalized()
		var target_basis = Basis.looking_at(dir, Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_basis, turn_speed * delta)
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)
	if Engine.get_physics_frames() % 30 == 0:
		print("dir_len=", dir.length(), " vel=", velocity, " pos=", global_position)

	move_and_slide()

func _set_target(pos: Vector3) -> void:
	var nav_map := get_world_3d().navigation_map
	if NavigationServer3D.map_get_iteration_id(nav_map) == 0:
		call_deferred("_set_target", pos)
		return
	var safe := NavigationServer3D.map_get_closest_point(nav_map, pos)
	agent.target_position = safe
	print("SET TARGET ON:",get_path()," agent:",agent.get_path()," -> ",safe)


func _current_patrol_target() -> Vector3:
	return patrol_points[patrol_index].global_position

func _can_see_player() -> bool:
	if player == null:
		return false

	# Raycast van monster naar speler (line of sight)
	ray.target_position = ray.to_local(player.global_position)
	ray.force_raycast_update()

	if not ray.is_colliding():
		return true

	var col = ray.get_collider()
	return col != null and (col == player or (col is Node and (col as Node).is_in_group("player")))

func _on_vision_body_entered(body: Node) -> void:
	if body is Node3D and body.is_in_group("player"):
		player = body
		time_since_seen = 0.0
		state = State.CHASE

func _on_vision_body_exited(body: Node) -> void:
	if body == player:
		pass

func set_patrol_points(holder: Node3D) -> void:
	patrol_points.clear()
	patrol_index = 0

	for c in holder.get_children():
		if c is Node3D:
			patrol_points.append(c)

	print("Nexulith patrol points:", patrol_points.size())

	if patrol_points.size() > 0:
		call_deferred("_set_target", patrol_points[patrol_index].global_position)
