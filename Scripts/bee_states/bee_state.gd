extends State
class_name BeeState

var bee : Bee
@onready var double_tap_timer := 0.0
@onready var double_tap_sensitivity := 0.2

func getInputs():
	return Vector3(Input.is_action_pressed("left"),Input.is_action_pressed("fly"),Input.is_action_pressed("right"))

func handleDoubleTap(new_time):
	var double_tap = false
	if new_time - double_tap_timer < double_tap_sensitivity * 1000:
		double_tap = true
	double_tap_timer = new_time
	return double_tap

func rotateSprite(lean_dir, mod, delta):
	bee.beeSprite.rotation.z = move_toward(bee.beeSprite.rotation.z, lean_dir*bee.max_lean*mod, bee.lean_speed*delta)
