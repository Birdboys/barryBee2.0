extends Node3D
class_name Boss

@export var bossAnim : AnimationPlayer
@export var hurtbox_list : Array[Area3D]
@export var hitbox_list : Array[Area3D]
@onready var stateMachine := $stateMachine
@onready var groundImpactParticle := preload("res://Scenes/ground_impact_particle.tscn")
var bee_follow_speed : float
var attacks : Array[String]
var finishers : Array[String]
var attack_angle := 0.0
var attack_pos : Vector3
var recovery_index : Dictionary
var anticipation_index : Dictionary
var fight_progress_done := false
var current_attack : String
var field_radius : float
var bee_angle := 0.0
var bee_pos : Vector3
var interrupted := false
signal camera_trauma(trauma)
signal change_progress(amount)
signal boss_defeated
signal ground_particle(amount, global_pos)

func _ready():
	stateMachine.initialize(self)
	for hurtbox in hurtbox_list:
		hurtbox.monitorable = false
		hurtbox.monitoring = false
		hurtbox.area_entered.connect(hurtTriggered)
	for hitbox in hitbox_list:
		hitbox.monitorable = false
		hitbox.monitoring = false
		
func handlePupils(delta, angle, pos):
	pass
	
func cameraTrauma(amount: float):
	emit_signal("camera_trauma", amount)

func hurtTriggered(area: Area3D):
	stateMachine.current_state.handleBeeInterrupt()

func fightProgressDone():
	fight_progress_done = true
	
func selectAttack():
	attack_angle = bee_angle
	attack_pos = bee_pos
	return attacks.pick_random()

func prepareAttackAnimation(attack: String):
	pass

func prepareRecoveryAnimation(anim: String):
	pass

func resetHurtbox():
	for box in hurtbox_list:
		box.set_deferred("monitorable",false)
		box.set_deferred("monitoring",false)

func resetHitbox():
	for box in hitbox_list:
		box.set_deferred("monitorable",false)
		box.set_deferred("monitoring",false)

func handleFace(face):
	pass

func emitGroundParticle(amount: int, body_part: String):
	var part = get_node(body_part)
	if part:
		emit_signal("ground_particle", amount,part.global_position)
