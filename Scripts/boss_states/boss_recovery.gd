extends BossState

@export var bossAnim : AnimationPlayer
var recovery : String
func _ready():
	bossAnim.animation_finished.connect(bossAttackFinished)
	
func enter():
	boss.resetHitbox()
	boss.resetHurtbox()
	recovery = boss.recovery_index[boss.current_attack]
	await boss.prepareRecoveryAnimation(recovery)
	bossAnim.play(recovery)

func bossAttackFinished(anim):
	if boss.stateMachine.current_state == self:
		if "recovery" in anim:
			emit_signal("transitioned", self, "bossIdle")

func exit():
	boss.current_attack = ""
