extends Node3D
@onready var homeScreen := preload("res://Scenes/temp_win_loss.tscn")
@onready var groundParticle := preload("res://Scenes/ground_impact_particle.tscn")
@onready var fieldHole := $levelRing/hole
@onready var fieldPlatform := $levelRing/platform
@onready var bee := $beeCharacter
@onready var boss := $polarBearBoss
@onready var fightTimer := $fightTimer
@onready var frontRing := $frontRing
@onready var backRing := $backRing
@onready var field_radius := 30.0
@onready var field_segments := 36
@onready var field_platform_length := 2.5
@onready var fight_length := 45.0
@onready var current_fight_progress := 0.0
@onready var total_player_fight_length : float

func _ready():
	setField(field_radius, field_segments, field_platform_length)
	placeBee(0)
	bee.position.y = 2
	boss.field_radius = field_radius + .1
	boss.camera_trauma.connect(bee.cameraTrauma)
	boss.change_progress.connect(increaseProgress)
	boss.boss_defeated.connect(bossDefeated)
	boss.ground_particle.connect(createGroundParticle)
	bee.game_over.connect(playerDefeated)
	bee.setStats(field_radius)
	fightTimer.start(fight_length)
	total_player_fight_length = Time.get_ticks_msec()

func _process(delta):
	boss.bee_angle = bee.getAngle()
	boss.bee_pos = bee.global_position
	bee.setProgressBar((fight_length-fightTimer.time_left)/fight_length*100.0)
	if Input.is_action_just_pressed("cheat"): increaseProgress(5)
	current_fight_progress += delta
	
func setField(radius, segments, platform_length=1.0):
	fieldPlatform.radius = radius + platform_length/2.0 + 1
	fieldPlatform.sides = segments
	fieldHole.radius = radius - platform_length/2.0
	fieldHole.sides = segments
	frontRing.mesh.top_radius = field_radius+field_platform_length/2.0 + 1
	frontRing.mesh.bottom_radius = field_radius+field_platform_length/2.0 + 1
	backRing.mesh.top_radius = field_radius-field_platform_length/2.0
	backRing.mesh.bottom_radius = field_radius-field_platform_length/2.0
	
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

func bossDefeated():
	total_player_fight_length = Time.get_ticks_msec() - total_player_fight_length
	TempData.time = total_player_fight_length / 1000
	TempData.win = true
	get_tree().call_deferred("change_scene_to_file","res://Scenes/temp_win_loss.tscn")
	 
func playerDefeated():
	if not boss.interrupted:
		TempData.win = false
		get_tree().call_deferred("change_scene_to_file","res://Scenes/temp_win_loss.tscn")

func createGroundParticle(amount, global_pos):
	var new_part = groundParticle.instantiate()
	add_child(new_part)
	var part_pos = Vector3(global_pos.x, 0.75, global_pos.z)#Vector3.FORWARD.signed_angle_to(Vector3(global_pos.x,0,global_pos.z))
	new_part.initialize(amount, part_pos, bee.position)
