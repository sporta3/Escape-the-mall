extends Node3D
@onready var label = $CanvasLayer/Control/Label
func show_tooltip(text: String):
	label.text = text
	label.visible = true

func hide_tooltip():
	label.visible = false
