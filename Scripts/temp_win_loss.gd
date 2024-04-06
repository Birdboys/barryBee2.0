extends Control

var win : bool
var time : float
func _ready():
	if TempData.win:
		$margins/VBoxContainer/win.visible = true
		$margins/VBoxContainer/win/VBoxContainer/time.text = "Time: %s" % str(TempData.time)
		$margins/VBoxContainer/lose.visible = false
	else:
		$margins/VBoxContainer/lose.visible = true
		$margins/VBoxContainer/win.visible = false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/test_level.tscn")
