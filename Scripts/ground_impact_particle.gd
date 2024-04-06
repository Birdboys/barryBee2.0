extends CPUParticles3D

func initialize(am, pos, look_pos):
	look_at(to_local(look_pos))
	rotation.x = 0
	rotation.z = 0
	global_position = pos
	amount = am
	emitting = true

func _on_lifetime_timeout():
	queue_free()
