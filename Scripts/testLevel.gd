extends Node3D
@onready var fieldHole := $levelRing/hole
@onready var fieldPlatform := $levelRing/platform
@onready var bee := $beeCharacter
@onready var boss := $baseBoss
@onready var fightTimer := $fightTimer
@onready var field_radius := 20.0
@onready var field_segments := 24
@onready var field_platform_length := 2.5
@onready var fight_length := 45.0
@onready var current_fight_progress := 0.0

func _ready():
	setField(field_radius, field_segments, field_platform_length)
	placeBee(0)
	bee.position.y = 2
	boss.field_radius = field_radius
	boss.camera_trauma.connect(bee.cameraTrauma)
	boss.change_progress.connect(increaseProgress)
	bee.setStats(field_radius)
	fightTimer.start(fight_length)
	
func _process(delta):
	boss.bee_angle = bee.getAngle()
	boss.bee_pos = bee.global_position
	bee.setProgressBar((fight_length-fightTimer.time_left)/fight_length*100.0)
	if Input.is_action_just_pressed("cheat"): increaseProgress(5)
	
func setField(radius, segments, platform_length=1):
	fieldPlatform.radius = radius + platform_length/2.0
	fieldPlatform.sides = segments
	fieldHole.radius = radius - platform_length/2.0
	fieldHole.sides = segments
	
func placeBee(deg):
	bee.position = Vector3.FORWARD.rotated(Vector3.UP, deg_to_rad(deg)) * field_radius

func increaseProgress(amount):
	var time_left = fightTimer.time_left
	fightTimer.stop()
	time_left -= amount
	time_left = max(0.01, time_left)
	fightTimer.start(time_left)
	
func _on_fight_timer_timeout():
	boss.fightProgressDone()
