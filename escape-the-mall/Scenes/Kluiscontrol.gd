extends Control

@onready var code_label = $"../code_label"

var juisteCode = []
var ingevoerd = []
var max = 6


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	juisteCode.resize(max)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_1_pressed() -> void:
	voeg_cijfer_toe(1)
	print("ik word ikgedrukt")


func _on_button_2_pressed() -> void:
	voeg_cijfer_toe(2)


func _on_button_3_pressed() -> void:
	voeg_cijfer_toe(3)


func _on_button_4_pressed() -> void:
	voeg_cijfer_toe(4)


func _on_button_5_pressed() -> void:
	voeg_cijfer_toe(5)


func _on_button_6_pressed() -> void:
	voeg_cijfer_toe(6)


func _on_button_7_pressed() -> void:
	voeg_cijfer_toe(7)


func _on_button_8_pressed() -> void:
	voeg_cijfer_toe(8)


func _on_button_9_pressed() -> void:
	voeg_cijfer_toe(9)


func _on_button_0_pressed() -> void:
	voeg_cijfer_toe(0)


func _on_button_pressed() -> void:
	pass


func _on_buttonster_pressed() -> void:
	pass


func voeg_cijfer_toe(cijfer: int) -> void:
	print(ingevoerd.size)
	print("+")
	print(max)
	if ingevoerd.size() < max:
		print("ja")
		ingevoerd.append(cijfer)
		update_label()

		if ingevoerd.size() == max:
			controleer_code()


func update_label() -> void:
	code_label.text = ""
	for cijfer in ingevoerd:
		code_label.text += str(cijfer)


func controleer_code() -> void:
	if ingevoerd == juisteCode:
		print("✅ Code correct!")
	else:
		print("❌ Code fout")

	ingevoerd.clear()
	update_label()


func voegRandomGetalToe():
	juisteCode.clear()
	for i in range(max):
		var cijfer := randi_range(0, 9)
		juisteCode[i] = cijfer
		print(cijfer)
	
