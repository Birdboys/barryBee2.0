extends BeeState

func update(delta):
	var inputs = getInputs()
	
	if Input.is_action_just_pressed("fly") and handleDoubleTap(Time.get_ticks_msec()):
		if bee.pollen_val > 0:
			if inputs.x or inputs.z:
				if bee.pollen_dash_flag:
					bee.updatePollen(-bee.pollen_dash_cost)
					emit_signal("transitioned", self, "beeDashing")
			else:
				bee.updatePollen(-bee.pollen_burst_cost)
				emit_signal("transitioned", self, "beeSlamming")
	if inputs.x:
		if inputs.y and bee.pollen_val >= 0:
			bee.bee_air_speed += bee.pollen_thrust_mult * bee.bee_air_acc * delta
		else:
			bee.bee_air_speed += bee.bee_air_acc * delta
	if inputs.z:
		if inputs.y and bee.pollen_val >= 0:
			bee.bee_air_speed -= bee.pollen_thrust_mult * bee.bee_air_acc * delta
		else:
			bee.bee_air_speed -= bee.bee_air_acc * delta
	if inputs.y:
		if bee.pollen_val > 0:
			bee.velocity.y += bee.pollen_lift * delta
		bee.updatePollen(-bee.pollen_use_rate*delta)
		
	bee.bee_air_speed = clamp(bee.bee_air_speed, -bee.bee_air_max_speed, bee.bee_air_max_speed)
	bee.velocity.y -= bee.gravity * delta
	bee.velocity.y = clamp(bee.velocity.y, -bee.bee_terminal_velocity, bee.bee_max_vert)
	bee.position = bee.position.rotated(Vector3.UP, -bee.bee_air_speed*delta)
	bee.move_and_slide()
	if bee.is_on_floor():
		emit_signal("transitioned", self, "beeGrounded")
