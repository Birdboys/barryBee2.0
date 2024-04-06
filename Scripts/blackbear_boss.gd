extends Boss

@onready var pawLeft := $bossPawLeft
@onready var pawRight := $bossPawRight
@onready var pawLeftSprite := $bossPawLeft/bossPawLeftSprite
@onready var pawRightSprite := $bossPawRight/bossPawRightSprite
@onready var bossHeadSprite := $bossHead/bossHeadSprite
@onready var bossHead := $bossHead
@onready var pupils := $bossHead/bossPupils
@onready var faceSprite := $bossHead/bossHeadSprite
@onready var pupil_max_hor_offset := 1.25
@onready var pupil_max_ver_offset := 1.0 

func _ready():
	super._ready()
	anticipation_index = {'attack1':'anticipation1','attack2':'anticipation2','attack3':'anticipation3','attack4':'anticipation4','attack5':'anticipation5','attack6':'anticipation6'}
	recovery_index = {'attack1':'recovery1','attack2':'recovery2','attack3':'recovery3','attack4':'recovery1','attack5':'recovery2','attack6':'recovery4'}
	attacks = ['attack1', 'attack2', 'attack3', 'attack4','attack5']
	finishers = ['attack6']
	bee_follow_speed = 50.0

func prepareAttackAnimation(attack: String):
	var attackAnim = bossAnim.get_animation(attack) as Animation
	match attack:
		"attack1":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.3)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.6)
			var key_id_4 = attackAnim.track_find_key(track_id, 3.5)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
		"attack2":
			var track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.3)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.6)
			var key_id_4 = attackAnim.track_find_key(track_id, 3.5)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(15)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(15)) * field_radius + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
		"attack3":
			var track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.3)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.6)
			var key_id_4 = attackAnim.track_find_key(track_id, 3.5)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(25)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(25)) * field_radius + (Vector3.UP * pawRightSprite.get_item_rect().size.y/2 * pawRightSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
			
			track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			key_id_1 = attackAnim.track_find_key(track_id, 0.3)
			key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			key_id_3 = attackAnim.track_find_key(track_id, 1.6)
			key_id_4 = attackAnim.track_find_key(track_id, 3.5)
			point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(25)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(25)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
		"attack4":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.35)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.0)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_4 = attackAnim.track_find_key(track_id, 2.0)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			var point3 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point3))
		"attack5":
			var track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.35)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.0)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_4 = attackAnim.track_find_key(track_id, 2.0)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			var point3 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeftSprite.get_item_rect().size.y/2 * pawLeftSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point3))
		"attack6":
			var track_id = attackAnim.find_track("bossHead:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.5)
			var key_id_2 = attackAnim.track_find_key(track_id, 2.0)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius * 0.75 + (Vector3.UP * bossHeadSprite.get_item_rect().size.y/2 * bossHeadSprite.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			
			track_id = attackAnim.find_track("bossHead:rotation", Animation.TYPE_VALUE)
			key_id_1 = attackAnim.track_find_key(track_id, 0.5)
			var bite_angle = angle_difference(rotation.y, attack_angle)
			attackAnim.track_set_key_value(track_id, key_id_1, Vector3(0,bite_angle,0))
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
		'recovery2':
			var track_id = recoveryAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawRight.position)
			
			track_id = recoveryAnim.find_track("bossPawRight:rotation", Animation.TYPE_VALUE)
			key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawRight.rotation)
		'recovery3':
			var track_id = recoveryAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawLeft.position)
			
			track_id = recoveryAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawRight.position)
		'recovery4':
			var track_id = recoveryAnim.find_track("bossHead:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, bossHead.position)
			
			track_id = recoveryAnim.find_track("bossHead:rotation", Animation.TYPE_VALUE)
			key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, bossHead.rotation)
		_: pass

func handlePupils(delta, angle, pos):
	var angle_dif = rad_to_deg(angle_difference(rotation.y, angle))
	var pup_hor_offset = remap(-angle_dif/3.0, -30.0, 30.0, -pupil_max_hor_offset,pupil_max_hor_offset)
	var pup_ver_offset = remap(pos.y, 2, 25, 0, pupil_max_ver_offset)
	var new_pupil_offset = Vector3(pup_hor_offset, pup_ver_offset + 1.717, -.05) 
	pupils.position = pupils.position.move_toward(new_pupil_offset, 1.0*delta)

func fightProgressDone():
	super.fightProgressDone()
	attacks = ['attack6','attack6','attack6','attack1', 'attack2', 'attack3', 'attack4','attack5']

func handleFace(face: String):
	match face:
		'neutral': 
			faceSprite.texture = load('res://Assets/bears/blackbear/blackbear_head.svg')
			pupils.visible = true
		'bite':
			faceSprite.texture = load('res://Assets/bears/blackbear/blackbear_head_bite.svg')
			pupils.visible = true
		'hurt':
			faceSprite.texture = load('res://Assets/bears/blackbear/blackbear_head_hurt.svg')
			pupils.visible = true
