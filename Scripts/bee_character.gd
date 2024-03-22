extends CharacterBody3D

@onready var gravity := 10.0
@onready var bee_speed := 1.0
@onready var bee_max_vert := 15.0
@onready var field_radius := 15.0
@onready var cam_offset := Vector3(0,5,-15)
@onready var pollen_charge_rate := 35.0
@onready var pollen_use_rate := 20.0
@onready var pollen_val := 0.0
@onready var pollen_thrust := gravity + 5.0
@onready var cam := $beeCam
@onready var pollenLabel := $beeUI/beeUIMargin/beePollenLabel
func _process(delta):
	handleInput(delta)
	handleFlying(delta)
	handlePollen(delta)
	moveCamera()
	
func handleInput(delta):
	if Input.is_action_pressed("left"):
		position = position.rotated(Vector3.UP, -bee_speed*delta)
	if Input.is_action_pressed("right"):
		position = position.rotated(Vector3.UP, bee_speed*delta)

func handleFlying(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func handlePollen(delta):
	if is_on_floor():
		pollen_val += pollen_charge_rate * delta
		pollen_val = min(pollen_val, 100)
	if Input.is_action_pressed("fly"):
		if pollen_val > 0:
			pollen_val -= pollen_use_rate * delta
			pollen_val = max(pollen_val, 0.0)
			velocity.y += pollen_thrust * delta
			velocity.y = min(velocity.y, bee_max_vert)
	pollenLabel.text = "Honey %s" % pollen_val
	
func moveCamera():
	cam.position = cam_offset.rotated(Vector3.UP, deg_to_rad(getAngle()))
	cam.look_at(Vector3(0, position.y, 0))
	
func getAngle():
	var rot_position = Vector3(position.x, 0, position.z)
	return rad_to_deg(Vector3.FORWARD.signed_angle_to(rot_position, Vector3.UP))

