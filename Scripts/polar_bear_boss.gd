extends Boss

@onready var snowBreath := $bossHead/snowBreathEmitter
@onready var pawLeft := $bossPawLeft
@onready var pawLeftHurtbox := $bossPawLeft/pawLeftHurtbox
@onready var pawLeftHitbox := $bossPawLeft/pawLeftHitbox
@onready var pawRight := $bossPawRight
@onready var pawRightHurtbox := $bossPawRight/pawRightHurtbox
@onready var pawRightHitbox := $bossPawRight/pawRightHitbox
@onready var bossHead := $bossHead
@onready var bossMuzzle := $bossHead/muzzleSprite
@onready var faceSprite := $bossHead/headSprite
@onready var pawLeftBall := $bossPawLeft/pawBall
@onready var pawRightBall := $bossPawRight/pawBall
@onready var pawLeftSprite := $bossPawLeft/pawLeftSprite
@onready var pawRightSprite := $bossPawRight/pawRightSprite
@onready var pupils := $bossHead/pupil
@onready var tongue := $bossHead/tongueSprite
@onready var freezeTimeLeft := $freezeTimeLeft
@onready var freezeTimeRight := $freezeTimeRight
@onready var pawAnim := $pawAnim
@onready var snowBall := preload("res://Scenes/projectile.tscn")
@onready var rollingSnowBall := preload("res://Scenes/snowball_stage_projectile.tscn")
@onready var pupil_max_hor_offset := 1.0
@onready var pupil_max_ver_offset := 1.0 
@onready var pawLeftFrozen := false
@onready var pawRightFrozen := false
@onready var should_thaw_left := false
@onready var should_thaw_right := false
@onready var freeze_time_min := 2.5
@onready var freeze_time_max := 10.0

var rolling_snowball_scl := 0.4
var rolling_snowball_speed := 0.4

func _ready():
	super._ready()
	anticipation_index = {'attack_paw_sweep_left':'anticipation_left_ear','attack_paw_sweep_right':'anticipation_right_ear','attack_big_snowball':'anticipation_lick_left','attack_many_snowballs':'anticipation_lick_right','attack_snowball_roll_right':'anticipation_left_ear','attack_snowball_roll_left':'anticipation_right_ear'}#,'attack2':'anticipation2','attack3':'anticipation3','attack4':'anticipation4','attack5':'anticipation5','attack6':'anticipation6'}
	recovery_index = {'attack_paw_sweep_left':'recovery1','attack_paw_sweep_right':'recovery1','attack_big_snowball':'recovery1','attack_many_snowballs':'recovery1','attack_snowball_roll_right':'recovery1','attack_snowball_roll_left':'recovery1'}#,'attack2':'recovery2','attack3':'recovery3','attack4':'recovery1','attack5':'recovery2','attack6':'recovery4'}
	attacks = ['attack_paw_sweep_left','attack_paw_sweep_right','attack_big_snowball']#['attack_big_snowball','attack_many_snowballs', 'attack_snowball_roll_right','attack_snowball_roll_left']
	finishers = ['attack6']
	bee_follow_speed = 40.0

func prepareAttackAnimation(attack: String):
	var attackAnim = bossAnim.get_animation(attack) as Animation
	match attack:
		"attack_paw_slam_left", "attack_paw_slam_right":
			var track_id
			var point1
			var point2
			if attack == "attack_paw_slam_left":
				track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
				point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
				point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			else:
				track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
				point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(15)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
				point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(15)) * field_radius + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.3)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.6)
			var key_id_4 = attackAnim.track_find_key(track_id, 3.5)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
		"attack_paw_sweep_left", "attack_paw_sweep_right":
			var track_id
			var point1
			var point2
			var point3
			if attack == "attack_paw_sweep_left":
				track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
				point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
				point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
				point3 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			else:
				track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
				point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(45)) * field_radius + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
				point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
				point3 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(45)) * field_radius + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.35)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.0)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_4 = attackAnim.track_find_key(track_id, 2.0)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point3))
		"attack_big_snowball","attack_many_snowballs":
			var track_id = attackAnim.find_track("bossPawLeft/pawLeftSprite:modulate", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.55)
			attackAnim.track_set_key_value(track_id, key_id_1, pawLeftSprite.modulate)
			
			track_id = attackAnim.find_track("bossPawRight/pawRightSprite:modulate", Animation.TYPE_VALUE)
			key_id_1 = attackAnim.track_find_key(track_id, 0.55)
			attackAnim.track_set_key_value(track_id, key_id_1, pawRightSprite.modulate)
		"attack_snowball_roll_right":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 3.0)
			var key_id_2 = attackAnim.track_find_key(track_id, 3.25)
			var ball_push_start_pos = getAttackPoint(attack_angle-deg_to_rad(30)) + Vector3.UP * (pawLeftBall.texture.get_width()/2 * pawLeftBall.pixel_size * rolling_snowball_scl)
			var ball_push_end_pos = getAttackPoint(attack_angle-deg_to_rad(15)) + Vector3.UP * (pawLeftBall.texture.get_width()/2 * pawLeftBall.pixel_size * rolling_snowball_scl)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(ball_push_start_pos))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(ball_push_end_pos))
		
			track_id = attackAnim.find_track("bossPawLeft/pawLeftSprite:modulate", Animation.TYPE_VALUE)
			key_id_1 = attackAnim.track_find_key(track_id, 0.55)
			attackAnim.track_set_key_value(track_id, key_id_1, pawLeftSprite.modulate)
		"attack_snowball_roll_left":
			var track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 3.0)
			var key_id_2 = attackAnim.track_find_key(track_id, 3.25)
			var ball_push_start_pos = getAttackPoint(attack_angle+deg_to_rad(30)) + Vector3.UP * (pawRightBall.texture.get_width()/2 * pawRightBall.pixel_size * rolling_snowball_scl)
			var ball_push_end_pos = getAttackPoint(attack_angle+deg_to_rad(15)) + Vector3.UP * (pawRightBall.texture.get_width()/2 * pawRightBall.pixel_size * rolling_snowball_scl)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(ball_push_start_pos))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(ball_push_end_pos))
			
			track_id = attackAnim.find_track("bossPawRight/pawRightSprite:modulate", Animation.TYPE_VALUE)
			key_id_1 = attackAnim.track_find_key(track_id, 0.55)
			attackAnim.track_set_key_value(track_id, key_id_1, pawRightSprite.modulate)
		_: pass
func prepareRecoveryAnimation(anim):
	var recoveryAnim = bossAnim.get_animation(anim) as Animation
	match anim:
		'recovery1':
			var track_id = recoveryAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawLeft.position)
			
			track_id = recoveryAnim.find_track("bossPawLeft:rotation", Animation.TYPE_VALUE)
			key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawLeft.rotation)
			
			track_id = recoveryAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawRight.position)
			
			track_id = recoveryAnim.find_track("bossPawRight:rotation", Animation.TYPE_VALUE)
			key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawRight.rotation)

func handleFace(face: String):
	match face:
		'neutral': 
			faceSprite.texture = load('res://Assets/bears/polarbear/polarbear_head.svg')
			snowBreath.emitting = false
			bossMuzzle.position = Vector3(0, -3.286, -0.1) 
			#pupils.visible = true
		'snow_breath':
			faceSprite.texture = load('res://Assets/bears/polarbear/polarbear_head_open_mouth.svg')
			snowBreath.emitting = true
			bossMuzzle.position = Vector3(0, -0.75, -0.1) 
			#pupils.visible = true
		'open_mouth_tongue':
			faceSprite.texture = load('res://Assets/bears/polarbear/polarbear_head_open_mouth.svg')
			bossMuzzle.position = Vector3(0, -2, -0.1) 

func createSnowball(size, angle, height, vel):
	var new_pos = Vector3.FORWARD.rotated(Vector3.UP, angle) * field_radius + Vector3.UP * height
	var new_snowball = snowBall.instantiate()
	add_child(new_snowball)
	new_snowball.initialize(size,"res://Assets/bears/polarbear/polarbear_ball.svg", vel)
	new_snowball.global_position = new_pos
	
func bigSnowball():
	createSnowball(7, attack_angle, 50, 5)

func manySnowball():
	for x in range(0, 360, 360/4):
		createSnowball(3, attack_angle + deg_to_rad(x), 75 + randi_range(0,5), 5)
		
func rollingSnowball(left: bool):
	var new_snowball = rollingSnowBall.instantiate()
	var speed_mod = 1
	var ball_pos
	if left:
		speed_mod = -1
		ball_pos = Vector3(pawRightBall.global_position.x, 0 ,pawRightBall.global_position.z).normalized() * field_radius + Vector3(0, pawRightBall.global_position.y, 0)
	else:
		ball_pos = Vector3(pawLeftBall.global_position.x, 0 ,pawLeftBall.global_position.z).normalized() * field_radius + Vector3(0, pawLeftBall.global_position.y, 0)
	add_child(new_snowball)
	new_snowball.initialize(rolling_snowball_speed * speed_mod, field_radius, pawLeftBall.texture.get_width()/2 * pawLeftBall.pixel_size * rolling_snowball_scl)
	new_snowball.global_position = ball_pos
	#print(pawLeftBall.global_position, Vector3(pawLeftBall.global_position.x, 0,pawLeftBall.global_position.z).length())

func handlePupils(delta, angle, pos):
	var angle_dif = rad_to_deg(angle_difference(rotation.y, angle))
	var pup_hor_offset = remap(-angle_dif/3.0, -30.0, 30.0, -pupil_max_hor_offset,pupil_max_hor_offset)
	var pup_ver_offset = remap(pos.y, 2, 25, 0, pupil_max_ver_offset)
	var new_pupil_offset = Vector3(pup_hor_offset, pup_ver_offset + 0.8, -.05) 
	pupils.position = pupils.position.move_toward(new_pupil_offset, 1.0*delta)

func freezePaw(paw_left: bool, paw_right: bool):
	var freeze_time = randf_range(freeze_time_min, freeze_time_max)
	if paw_left:
		should_thaw_left = false
		pawLeftFrozen = true
		freezeTimeLeft.start(freeze_time)
	if paw_right:
		should_thaw_right = false
		pawRightFrozen = true
		freezeTimeRight.start(freeze_time)

func unfreezePaw():
	if (pawLeftFrozen and should_thaw_left) and (pawRightFrozen and should_thaw_right):
		should_thaw_left = false
		should_thaw_right = false
		pawRightFrozen = false
		pawLeftFrozen = false
		pawAnim.play("unfreeze_both")
	elif pawRightFrozen and should_thaw_right:
		should_thaw_right = false
		pawRightFrozen = false
		pawAnim.play("unfreeze_right")
	elif pawLeftFrozen and should_thaw_left:
		should_thaw_left = true
		pawLeftFrozen = false
		pawAnim.play("unfreeze_left")
		
func _on_freeze_time_left_timeout():
	should_thaw_left = true
func _on_freeze_time_right_timeout():
	should_thaw_right = true

func toggleHitboxes(parts: Array, on: bool):
	for part in parts:
		match part:
			"pawLeft":
				pawLeftHitbox.monitorable = on
				pawLeftHurtbox.monitoring = on
				if on and pawLeftFrozen:
					pawLeftHurtbox.monitoring = false
			"pawRight":
				pawRightHitbox.monitorable = on
				pawRightHurtbox.monitoring = on
				if on and pawRightFrozen:
					pawRightHurtbox.monitoring = false
