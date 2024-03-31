extends Boss

@onready var pawLeft := $bossPawLeft
@onready var pawRight := $bossPawRight
@onready var pawLeftSprite := $bossPawLeft/bossPawLeftSprite
@onready var pawRightSprite := $bossPawRight/bossPawRightSprite
@onready var pupils := $bossHead/bossPupils
@onready var pupil_max_hor_offset := 1.25
@onready var pupil_max_ver_offset := 1.0
func _ready():
	super._ready()
	anticipation_index = {'attack1':'anticipation1'}
	recovery_index = {'attack1':'recovery1'}
	attacks = ['attack1']#['attack1','attack2','attack3','attack4','attack5']
	bee_follow_speed = 50.0
	
func _process(delta):
	handlePupils(delta)
	
func prepareAttackAnimation(attack: String):
	var attackAnim = bossAnim.get_animation(attack) as Animation
	match attack:
		"attack1":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.3)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.65)
			var key_id_4 = attackAnim.track_find_key(track_id, 3.5)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
		_: pass

func prepareRecoveryAnimation(anim):
	var recoveryAnim = bossAnim.get_animation(anim) as Animation
	match anim:
		'recovery1':
			var track_id = recoveryAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.5)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawLeft.position)
		_: pass

func handlePupils(delta):
	var angle_dif = rad_to_deg(angle_difference(rotation.y, bee_angle))
	var pup_hor_offset = remap(-angle_dif/3.0, -30.0, 30.0, -pupil_max_hor_offset,pupil_max_hor_offset)
	var pup_ver_offset = remap(bee_pos.y, 2, 25, 0, pupil_max_ver_offset)
	var new_pupil_offset = Vector3(pup_hor_offset, pup_ver_offset + 1.717, -.05) 
	pupils.position = pupils.position.move_toward(new_pupil_offset, 1.0*delta)
