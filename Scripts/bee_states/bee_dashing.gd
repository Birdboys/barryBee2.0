extends State
@onready var dash_cooldown := 1.5

func enter():
	if Input.is_action_pressed("left"): bee.beeAnim.play("dash_left")
	elif Input.is_action_pressed("right"): bee.beeAnim.play("dash_right")
	bee.pollen_dash_flag = false
	bee.velocity.y = 0
	
func update(delta):
	bee.position = bee.position.rotated(Vector3.UP, -bee.bee_air_speed*delta)
		
func exit():
	setDashTimer()

func setDashTimer():
	await get_tree().create_timer(dash_cooldown).timeout
	bee.pollen_dash_flag = true
	
func _on_bee_anim_animation_finished(anim_name):
	if "dash" in anim_name:
		emit_signal("transitioned", self, "beeFlying")


