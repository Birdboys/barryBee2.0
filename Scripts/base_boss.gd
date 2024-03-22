extends Node3D
@onready var attackTimer := $attackTimer
@onready var pawLeft := $bossPawLeft
@onready var bossAnim := $bossAnim
@onready var bee_follow_speed := 50
@onready var attacks = ['anticipation4']
@onready var field_radius := 15.0
@export var bee_angle := 0.0
@export var bee_pos : Vector3
func _ready():
	bossAnim.play("idle")
	
func _process(delta):
	if bossAnim.current_animation == "idle" or "anticipation"  in bossAnim.current_animation:
		if rad_to_deg(abs(angle_difference(rotation.y, bee_angle))) > 30:
			rotation.y = bee_angle - deg_to_rad(30) * sign(angle_difference(rotation.y, bee_angle))

func _on_attack_timer_timeout():
	var current_attack = attacks.pick_random()
	bossAnim.play(current_attack)

func startAttack(attack: String):
	var attackAnim = bossAnim.get_animation(attack) as Animation
	match attack:
		"attack1":
			var track_id = attackAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = attackAnim.track_find_key(track_id, 0.5)
			var key_id_2 = attackAnim.track_find_key(track_id, 1)
			var key_id_3 = attackAnim.track_find_key(track_id, 1.3)
			var key_id_4 = attackAnim.track_find_key(track_id, 2)
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, bee_angle) * field_radius + Vector3.UP * 20
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, bee_angle) * field_radius
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
			var point1 = Vector3.FORWARD.rotated(Vector3.UP, bee_angle-deg_to_rad(30)) * field_radius
			var point2 = Vector3.FORWARD.rotated(Vector3.UP, bee_angle) * field_radius
			var point3 = Vector3.FORWARD.rotated(Vector3.UP, bee_angle+deg_to_rad(30)) * field_radius
			attackAnim.track_set_key_value(track_id, key_id_1, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_2, to_local(point1))
			attackAnim.track_set_key_value(track_id, key_id_3, to_local(point2))
			attackAnim.track_set_key_value(track_id, key_id_4, to_local(point3))
	bossAnim.play(attack)

func startRecovery(recovery: String):
	var recoveryAnim = bossAnim.get_animation(recovery) as Animation
	match recovery:
		'recovery1':
			var track_id = recoveryAnim.find_track("bossPawLeft:position", Animation.TYPE_VALUE)
			var key_id_1 = recoveryAnim.track_find_key(track_id, 0.5)
			recoveryAnim.track_set_key_value(track_id, key_id_1, pawLeft.position)
	bossAnim.play(recovery)
	
func recovered():
	attackTimer.start(randi_range(2,5))
	bossAnim.play("idle")
