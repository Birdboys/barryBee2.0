extends Node3D
class_name Boss
@onready var pawLeft := $bossPawLeft
@onready var pawRight := $bossPawRight
@onready var bossHead := $bossHead
@onready var bossAnim := $bossAnim
@onready var stateMachine := $stateMachine
@onready var bee_follow_speed := 50
@onready var attacks = ['attack1','attack2','attack3','attack4','attack5']
@onready var attack_angle := 0.0
@onready var recovery_index := {'attack1':'recovery1','attack2':'recovery2','attack3':'recovery3',
'attack4':'recovery1','attack5':'recovery2','attack6':'recovery4'}
@onready var anticipation_index := {'attack1':'anticipation1','attack2':'anticipation2','attack3':'anticipation3','attack4':'anticipation4','attack5':'anticipation5','attack6':'anticipation6'}
@onready var finisher := "attack6"
@onready var fight_progress_done := false
@onready var current_attack : String
@export var bee_angle := 0.0
@export var bee_pos : Vector3
@export var hurtbox_list : Array[Area3D]
@export var hitbox_list : Array[Area3D]
var field_radius : float
signal camera_trauma(trauma)
signal change_progress(amount)
signal boss_defeated
func _ready():
	stateMachine.initialize(self)
	bossAnim.speed_scale = 1.25
	for hurtbox in hurtbox_list:
		hurtbox.area_entered.connect(hurtTriggered)

func cameraTrauma(amount: float):
	emit_signal("camera_trauma", amount)

func hurtTriggered(area: Area3D):
	stateMachine.current_state.handleBeeInterrupt()

func fightProgressDone():
	fight_progress_done = true

func selectAttack():
	attack_angle = bee_angle
	return attacks.pick_random()

func prepareAttackAnimation(attack):
	var attackAnim = bossAnim.get_animation(attack) as Animation
	match attack:
		"attack1":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.5)
			var key_id_2 = attackAnim.track_find_key(track_id, 1)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.3)
			var key_id_4 = attackAnim.track_find_key(track_id, 2)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(15)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
			
		"attack2":
			var track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.5)
			var key_id_2 = attackAnim.track_find_key(track_id, 1)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.3)
			var key_id_4 = attackAnim.track_find_key(track_id, 2)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(15)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(15)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
			print(pawLeft.get_item_rect())
		"attack3":
			var track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.5)
			var key_id_2 = attackAnim.track_find_key(track_id, 1)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.3)
			var key_id_4 = attackAnim.track_find_key(track_id, 2)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(25)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(25)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
			print(pawLeft.get_item_rect())
			track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			key_id_1 = attackAnim.track_find_key(track_id, 0.5)
			key_id_2 = attackAnim.track_find_key(track_id, 1)
			key_id_3 = attackAnim.track_find_key(track_id, 1.3)
			key_id_4 = attackAnim.track_find_key(track_id, 2)
			point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(25)) * field_radius + Vector3.UP * 20 + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(25)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point2))
		"attack4":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.75)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_3 = attackAnim.track_find_key(track_id, 2)
			var key_id_4 = attackAnim.track_find_key(track_id, 2.5)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			var point3 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point3))
		"attack5":
			var track_id = attackAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.75)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var key_id_3 = attackAnim.track_find_key(track_id, 2)
			var key_id_4 = attackAnim.track_find_key(track_id, 2.5)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle+deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			var point3 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle-deg_to_rad(45)) * field_radius + (Vector3.UP * pawLeft.get_item_rect().size.y/2 * pawLeft.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point3))
		"attack6":
			var track_id = attackAnim.find_track("bossHead:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.7)
			var key_id_2 = attackAnim.track_find_key(track_id, 1.5)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, attack_angle) * field_radius * 0.9 + (Vector3.UP * bossHead.get_item_rect().size.y/2 * pawLeft.pixel_size)
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))

func prepareRecoveryAnimation(anim):
	var recoveryAnim = bossAnim.get_animation(anim) as Animation
	match anim:
		'recovery1':
			var track_id = recoveryAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.5)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawLeft.position)
		'recovery2':
			var track_id = recoveryAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.5)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawRight.position)
		'recovery3':
			var track_id = recoveryAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.5)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawLeft.position)
			
			track_id = recoveryAnim.find_track("bossPawRight:position", Animation.TYPE_VALUE)
			key_id_1 = recoveryAnim.track_find_key(track_id, 0.5)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawRight.position)
		'recovery4':
			var track_id = recoveryAnim.find_track("bossHead:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.0)
			recoveryAnim.track_set_key_value(track_id, key_id_1, bossHead.position)

func resetHurtbox():
	for box in hurtbox_list:
		box.set_deferred("monitoring",false)

func resetHitbox():
	for box in hitbox_list:
		box.set_deferred("monitorable",false)
