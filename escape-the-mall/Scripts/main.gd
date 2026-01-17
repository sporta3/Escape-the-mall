extends Node3D
var niks = 0
@onready var startMenu := $Menu/"Start menu"/CanvasLayer/Control
@onready var pauzeMenu := $Menu/"Start menu"/CanvasLayer/Control
@onready var endMenu := $Menu/"Start menu"/CanvasLayer/Control
@onready var nexulith := $Entity/NPC/Hostile/Nexulith
@onready var map := $"Time Line/World/Mall_V2"
@onready var kluis_ui: CanvasLayer = $"Time Line/World/Objects/Interactable/kluisinterface/CanvasLayer"
var GameStarted = false
var alive = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	var patrol_holder := map.get_node("PatrolPoints") as Node3D
	if patrol_holder == null:
		push_error("PatrolPoints niet gevonden in Mall_V2")
		return
	nexulith.set_patrol_points(patrol_holder)
	toggle_pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	var paused := get_tree().paused
	if kluis_ui.visible:
		kluis_ui.visible = false
	get_tree().paused = !paused
	if !GameStarted:
		startMenu.visible = !paused
	if GameStarted:
		pauzeMenu.visable = !paused
	if !alive && GameStarted:
		endMenu.visable = !paused
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
