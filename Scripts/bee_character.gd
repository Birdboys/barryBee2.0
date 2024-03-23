extends CharacterBody3D

@onready var gravity := 10.0
@onready var bursting := false
@onready var bee_health := 3
@onready var bee_speed := 0.5
@onready var bee_air_acc := 1
@onready var bee_air_max_speed := 0.75
@export var bee_air_speed := 0.0
@onready var bee_max_vert := 8
@onready var bee_jump_boost := 2.0
@onready var field_height := 5.0
@onready var field_radius := 15.0
@onready var cam_offset := Vector3(0,8,-15)
@onready var pollen_charge_rate := 35.0
@onready var pollen_use_rate := 20.0
@onready var pollen_val := 0.0
@onready var pollen_thrust := gravity + 7.5
@onready var pollen_dash_cost := 15.0
@onready var pollen_dash_dist := deg_to_rad(20)
@onready var pollen_burst_cost := 30.0
@onready var pollen_burst_thrust := 30.0
@onready var double_tap_timer := 0.0
@onready var double_tap_sensitivity := 0.2
@onready var cam := $beeCam
@onready var pollenBar := $beeUI/beeUIMargin/UIBars/pollenBar
@onready var progressBar := $beeUI/beeUIMargin/UIBars/progressBar
@onready var beeAnim := $beeAnim

func _process(delta):
	handleInput(delta)
	handleFlying(delta)
	handlePollen(delta)
	moveCamera()
	
func handleInput(delta):
	if is_on_floor():
		if Input.is_action_pressed("left"):
			position = position.rotated(Vector3.UP, -bee_speed*delta)
		if Input.is_action_pressed("right"):
			position = position.rotated(Vector3.UP, bee_speed*delta)
	
func handleFlying(delta):
	if not is_on_floor() and not bursting:
		velocity.y -= gravity * delta
		position = position.rotated(Vector3.UP, -bee_air_speed*delta)
	move_and_slide()

func handlePollen(delta):
	if is_on_floor():
		pollen_val += pollen_charge_rate * delta
		pollen_val = min(pollen_val, 100)
		bursting = false
	if Input.is_action_just_pressed("fly") and not bursting:
		if is_on_floor():
			if Input.is_action_pressed("left"):
				bee_air_speed = bee_speed
			elif Input.is_action_pressed("right"):
				bee_air_speed = -bee_speed
			else:
				bee_air_speed = 0.0
			velocity.y = bee_jump_boost
		var new_time = Time.get_ticks_msec()
		if new_time - double_tap_timer < double_tap_sensitivity * 1000:
			pollenBurst()
		double_tap_timer = new_time
	if Input.is_action_pressed("fly") and not bursting:
		if pollen_val > 0:
			pollen_val -= pollen_use_rate * delta
			pollen_val = max(pollen_val, 0.0)
			if Input.is_action_pressed("left"):
				bee_air_speed += bee_air_acc*delta
			if Input.is_action_pressed("right"):
				bee_air_speed -= bee_air_acc*delta
			bee_air_speed = clamp(bee_air_speed, -bee_air_max_speed, bee_air_max_speed)
			velocity.y += pollen_thrust * delta
			velocity.y = min(velocity.y, bee_max_vert)
	pollenBar.value = pollen_val
	
func pollenBurst():
	if pollen_val > 0 and not is_on_floor() and not bursting:
		if Input.is_action_pressed("left"):
			pollen_val -= pollen_dash_cost
			beeAnim.play("dash_left")
			bee_air_speed = bee_air_max_speed
		elif Input.is_action_pressed("right"):
			pollen_val -= pollen_dash_cost
			beeAnim.play("dash_right")
			bee_air_speed = -bee_air_max_speed
		else:
			pollen_val -= pollen_burst_cost
			velocity.y = -pollen_burst_thrust
			bursting = true
		pollen_val = max(pollen_val, 0)
		
func moveCamera():
	var cam_angle = Vector3.FORWARD.signed_angle_to(Vector3(cam.position.x,0,cam.position.z), Vector3.UP)
	var new_angle = lerp_angle(cam_angle, getAngle(), 0.05)
	cam.position = cam_offset.rotated(Vector3.UP, new_angle) - Vector3(0, position.y, 0)
	cam.look_at(Vector3(0, cam_offset.y, 0))
	
func getAngle():
	var rot_position = Vector3(position.x, 0, position.z)
	return Vector3.FORWARD.signed_angle_to(rot_position, Vector3.UP)

func setProgressBar(val):
	progressBar.value = val
	
func _on_bee_hurtbox_area_entered(area):
	bee_health-=1
	print("bee hit")
