extends Node3D
@onready var ui = $tooltip
@onready var label = $tooltip/CanvasLayer/Control/label
@onready var kluisInterface = $"../kluisinterface"
@onready var kluis_ui: CanvasLayer = $"../kluisinterface/CanvasLayer"

var _player_in_range := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pauze"):
		kluis_ui.visible = false
		kluisInterface.visible = false
	if _player_in_range and Input.is_action_just_pressed("interact"):
		kluis_ui.visible = !kluis_ui.visible
		kluisInterface.visible = !kluisInterface.visible

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ui.show_tooltip("Druk E om te openen")
		_player_in_range = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ui.hide_tooltip()
		_player_in_range = false

func _on_kluisinterface_visibility_changed() -> void:
	if kluis_ui.visible == false:
			ui.show_tooltip("Druk E om te openen")
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if kluis_ui.visible == true:
			ui.show_tooltip("Druk E om te sluiten")
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
