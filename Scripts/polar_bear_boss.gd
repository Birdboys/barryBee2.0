extends Boss

@onready var snowBreath := $bossHead/snowBreathEmitter
@onready var pawLeft := $bossPawLeft
@onready var pawRight := $bossPawRight
@onready var bossHead := $bossHead
@onready var faceSprite := $bossHead/headSprite
@onready var pawLeftBall := $bossPawLeft/pawBall
@onready var snowBall := preload("res://Scenes/projectile.tscn")
@onready var rollingSnowBall := preload("res://Scenes/snowball_stage_projectile.tscn")

var rolling_snowball_scl := 0.4
var rolling_snowball_speed := 0.4
func _ready():
	super._ready()
	anticipation_index = {'attack3':'anticipation1'}#,'attack2':'anticipation2','attack3':'anticipation3','attack4':'anticipation4','attack5':'anticipation5','attack6':'anticipation6'}
	recovery_index = {'attack3':'recovery1'}#,'attack2':'recovery2','attack3':'recovery3','attack4':'recovery1','attack5':'recovery2','attack6':'recovery4'}
	attacks = ['attack3']#, 'attack2', 'attack3', 'attack4','attack5']
	finishers = ['attack6']
	bee_follow_speed = 40.0

func prepareAttackAnimation(attack: String):
	var attackAnim = bossAnim.get_animation(attack) as Animation
	match attack:
		"attack1":
			pass
		"attack3":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 3.0)
			var key_id_2 = attackAnim.track_find_key(track_id, 3.25)
			var ball_push_start_pos = getAttackPoint(attack_angle-deg_to_rad(15)) + Vector3.UP * (pawLeftBall.texture.get_width()/2 * pawLeftBall.pixel_size * rolling_snowball_scl)
			var ball_push_end_pos = getAttackPoint(attack_angle-deg_to_rad(5)) + Vector3.UP * (pawLeftBall.texture.get_width()/2 * pawLeftBall.pixel_size * rolling_snowball_scl)
			attackAnim.track_set_key_value(track_id, key_id_1, ball_push_start_pos)
			attackAnim.track_set_key_value(track_id, key_id_2, ball_push_end_pos)
			
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
			#pupils.visible = true
		'snow_breath':
			faceSprite.texture = load('res://Assets/bears/polarbear/polarbear_head_open_mouth.svg')
			snowBreath.emitting = true
			#pupils.visible = true

func createSnowball(size, angle, height, vel):
	var new_pos = Vector3.FORWARD.rotated(Vector3.UP, angle) * field_radius + Vector3.UP * height
	var new_snowball = snowBall.instantiate()
	add_child(new_snowball)
	new_snowball.initialize(size,"res://Assets/bears/polarbear/polarbear_ball.svg", vel)
	new_snowball.global_position = new_pos
	
func bigSnowball():
	createSnowball(7, attack_angle, 50, 5)

func rollingSnowball(left: bool):
	var new_snowball = rollingSnowBall.instantiate()
	add_child(new_snowball)
	new_snowball.initialize(rolling_snowball_speed, field_radius, pawLeftBall.texture.get_width()/2 * pawLeftBall.pixel_size * rolling_snowball_scl)
	new_snowball.global_position = pawLeftBall.global_position
