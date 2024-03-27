extends BossState

@export var bossAnim : AnimationPlayer
var attack : String
func _ready():
	bossAnim.animation_finished.connect(bossAttackFinished)
	
func enter():
	attack = boss.current_attack
	boss.bossAnim.play(attack)
	
func bossAttackFinished(anim):
	if boss.stateMachine.current_state == self:
		if "attack" in anim:
			emit_signal("transitioned", self, "bossRecovery")

func handleBeeInterrupt():
	boss.emit_signal("change_progress", 5.0)
	emit_signal("transitioned", self, "bossRecovery")
