extends BossState

@export var bossAnim : AnimationPlayer
var recovery : String
func _ready():
	bossAnim.animation_finished.connect(bossAttackFinished)
	
func enter():
	recovery = boss.recovery_index[boss.current_attack]
	await boss.prepareRecoveryAnimation(recovery)
	bossAnim.play(recovery)
	if boss.interrupted:
		boss.handleFace("hurt")
	else:
		boss.handleFace("neutral")
		
func update(delta):
	boss.handlePupils(delta, boss.bee_angle, boss.bee_pos)

func bossAttackFinished(anim):
	if boss.stateMachine.current_state == self:
		if "recovery" in anim:
			emit_signal("transitioned", self, "bossIdle")

func exit():
	boss.current_attack = ""
	boss.interrupted = false
	boss.handleFace("neutral")
