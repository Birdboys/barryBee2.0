extends CharacterBody3D
class_name Bee
@onready var gravity := 10.0
@onready var bee_health := 3
@onready var bee_air_acc := 1.5
@export var bee_air_speed := 0.0
@onready var bee_max_vert := 8
@onready var bee_terminal_velocity := 55.0
@onready var bee_jump_boost := 2.0
@onready var pollen_charge_rate := 35.0
@onready var pollen_use_rate := 40.0
@onready var pollen_val := 0.0
@onready var pollen_lift := gravity + 7.5
@onready var pollen_thrust_mult := 2.0
@onready var pollen_dash_cost := 15.0
@onready var pollen_dash_dist := deg_to_rad(20)
@onready var pollen_dash_flag := true
@onready var pollen_burst_cost := 30.0
@onready var pollen_burst_thrust := 75.0
@onready var double_tap_timer := 0.0
@onready var double_tap_sensitivity := 0.2
@onready var cam_move_speed := 10.0
@onready var lean_speed := 3.0
@onready var max_lean := deg_to_rad(10)
@onready var cam := $beeCamArm/beeCam
@onready var camArm := $beeCamArm
@onready var beeSprite := $beeSprite
@onready var beePollenSprite := $beeSprite/beePollenSprite
@onready var pollenBar := $beeUI/beeUIMargin/UIBars/pollenBar
@onready var progressBar := $beeUI/beeUIMargin/UIBars/progressBar
@onready var beeAnim := $beeAnim
@onready var stateMachine := $stateMachine
@onready var mobileButtons := $beeUI/mobileButtons
@onready var fpsLabel := $beeUI/beeUIMargin/fpsLabel
@onready var pollenEmitters := $beeSprite/pollenEmitters
@onready var pollenBurstEmitters := $beeSprite/pollenBurstEmitters
@onready var stinger := $beeStinger as Area3D

var bee_speed : float
var bee_air_max_speed : float
var field_radius : float
var field_height : float
var cam_offset : Vector3 #8, -15
func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	stateMachine.initialize(self)
	initializeMobileButtons()
	
func _process(delta):
	moveCamera(delta)
	beeSprite.rotation.y = getAngle()
	fpsLabel.text = "FPS:%s" % int(Engine.get_frames_per_second())
func updatePollen(amount):
	pollen_val += amount
	pollen_val = clamp(pollen_val, 0, 100)
	pollenBar.value = pollen_val
	
func moveCamera(delta):
	var cam_angle = Vector3.FORWARD.signed_angle_to(Vector3(camArm.position.x,0,camArm.position.z), Vector3.UP)
	var new_angle = lerp_angle(cam_angle, getAngle(), 0.05)
	camArm.position = camArm.position.move_toward(cam_offset.rotated(Vector3.UP, new_angle) - Vector3(0, position.y, 0), delta*cam_move_speed)
	camArm.position.y = cam_offset.y-position.y
	camArm.look_at(Vector3(0, cam_offset.y, 0))
	
func getAngle():
	var rot_position = Vector3(position.x, 0, position.z)
	return Vector3.FORWARD.signed_angle_to(rot_position, Vector3.UP)

func setProgressBar(val):
	progressBar.value = val
	
func _on_bee_hurtbox_area_entered(area):
	bee_health-=1
	print("bee hit")

func initializeMobileButtons():
	var screen_size = get_viewport().size
	var button_size = screen_size/2
	for x in range(0, mobileButtons.get_child_count()):
		var button := mobileButtons.get_child(x)
		button.shape.size = button_size 
		button.global_position = Vector2(0, screen_size.y-button_size.y) + x * Vector2(button_size.x,0) + button_size/2.0

func cameraTrauma(trauma):
	cam.changeTrauma(trauma)

func setPollenEmission(val:bool):
	for child in pollenEmitters.get_children():
		if child is CPUParticles3D: 
			child.emitting = val
		
func setStats(rad : float):
	field_radius = rad
	field_height = 10
	bee_speed = 7.5/rad
	bee_air_max_speed = 1.5 * bee_speed
	cam_offset = Vector3(0, 8, -0.6 * rad)

func setPollenBurst(am, dir):
	for child in pollenBurstEmitters.get_children():
		if child is CPUParticles3D:
			child.burst(am, dir)
