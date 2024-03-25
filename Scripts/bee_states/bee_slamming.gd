extends State

func enter():
	bee.velocity = Vector3(0,-bee.pollen_burst_thrust, 0)
	bee.bee_air_speed = 0
	bee.stinger.monitorable = true
	
func update(delta):
	bee.move_and_slide()
	if bee.is_on_floor():
		emit_signal("transitioned", self, "beeGrounded")

func exit():
	bee.stinger.monitorable = false
