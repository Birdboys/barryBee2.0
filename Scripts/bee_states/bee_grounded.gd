extends BeeState

@onready var jump_boost := 5.0

func enter():
	bee.setPollenEmission(false)
	
func update(delta):
	bee.updatePollen(bee.pollen_charge_rate*delta)
	var inputs = getInputs()
	rotateSprite((inputs.x * -1) + (inputs.z * 1),1.0,delta)
	if inputs.x:
		bee.position = bee.position.rotated(Vector3.UP, -bee.bee_speed*delta)
	if inputs.z:
		bee.position = bee.position.rotated(Vector3.UP, bee.bee_speed*delta)
	if Input.is_action_just_pressed("fly"):
		if bee.pollen_val > 0:
			bee.updatePollen(-bee.pollen_use_rate*delta)
			bee.bee_air_speed = (inputs.x * 1) + (inputs.z * -1)
			bee.velocity.y = jump_boost
			emit_signal("transitioned", self, "beeFlying")

