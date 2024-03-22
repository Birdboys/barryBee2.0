extends Node3D
@onready var fieldHole := $levelRing/hole
@onready var fieldPlatform := $levelRing/platform
@onready var bee := $beeCharacter
@onready var boss := $baseBoss
@onready var fightTimer := $fightTimer
@onready var field_radius := 15.0
@onready var field_segments := 24
@onready var field_platform_length := 2
@onready var bee_radius := field_radius-(field_platform_length/2.0)
@onready var fight_length := 45.0
@onready var current_fight_progress := 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	setField(field_radius, field_segments, field_platform_length)
	placeBee(15)
	bee.position.y = 2
	boss.field_radius = bee_radius + 1
	bee.field_radius = bee_radius
	fightTimer.start(fight_length)
	
func _process(delta):
	boss.bee_angle = bee.getAngle()
	boss.bee_pos = bee.global_position
	bee.setProgressBar((fight_length-fightTimer.time_left)/fight_length*100.0)
	if Input.is_action_just_pressed("cheat"): increaseProgress(5)
	
func setField(radius, segments, platform_length=1):
	fieldPlatform.radius = radius
	fieldPlatform.sides = segments
	fieldHole.radius = radius - platform_length
	fieldHole.sides = segments
	
func placeBee(deg):
	bee.position = Vector3.FORWARD.rotated(Vector3.UP, deg_to_rad(deg)) * bee_radius

func increaseProgress(amount):
	var time_left = fightTimer.time_left
	fightTimer.stop()
	time_left -= amount
	time_left = max(0.01, time_left)
	fightTimer.start(time_left)
	
