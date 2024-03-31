extends Node3D
class_name Boss

@export var bossAnim : AnimationPlayer
@export var hurtbox_list : Array[Area3D]
@export var hitbox_list : Array[Area3D]
@onready var stateMachine := $stateMachine

var bee_follow_speed : float
var attacks : Array[String]
var attack_angle := 0.0
var recovery_index : Dictionary
var anticipation_index : Dictionary
var fight_progress_done := false
var current_attack : String
var field_radius : float
var bee_angle := 0.0
var bee_pos : Vector3
signal camera_trauma(trauma)
signal change_progress(amount)
signal boss_defeated

func _ready():
	stateMachine.initialize(self)
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

func prepareAttackAnimation(attack: String):
	pass

func prepareRecoveryAnimation(anim: String):
	pass

func resetHurtbox():
	for box in hurtbox_list:
		box.set_deferred("monitoring",false)

func resetHitbox():
	for box in hitbox_list:
		box.set_deferred("monitorable",false)
