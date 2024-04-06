extends BeeState
@onready var dash_cooldown := 1.0
var dash_dir : int
func enter():
	bee.hurtbox.set_deferred("monitoring",false)
	bee.hurtbox.set_deferred("monitorable",false)
	if Input.is_action_pressed("left"): 
		bee.beeAnim.play("dash_left")
		dash_dir = -1
	elif Input.is_action_pressed("right"): 
		bee.beeAnim.play("dash_right")
		dash_dir = 1
	bee.pollen_dash_flag = false
	bee.velocity.y = 0
	bee.setPollenBurst(12, Vector3.LEFT * dash_dir)
	
func update(delta):
	bee.position = bee.position.rotated(Vector3.UP, -bee.bee_air_speed*delta)
	rotateSprite(dash_dir,1.5,delta)
	
func exit():
	bee.hurtbox.set_deferred("monitoring",true)
	bee.hurtbox.set_deferred("monitorable",true)
	setDashTimer()

func setDashTimer():
	await get_tree().create_timer(dash_cooldown).timeout
	bee.pollen_dash_flag = true
	
func _on_bee_anim_animation_finished(anim_name):
	if "dash" in anim_name:
		emit_signal("transitioned", self, "beeFlying")


