extends Node3D

@onready var startMenu := $Menu/"Start menu"/CanvasLayer/Control
@onready var pauzeMenu := $Menu/"Start menu"/CanvasLayer/Control
@onready var endMenu := $Menu/"Start menu"/CanvasLayer/Control
var GameStarted = false
var alive = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	var paused := get_tree().paused
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
