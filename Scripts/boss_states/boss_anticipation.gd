extends BossState

var anticipation : String
@export var bossAnim : AnimationPlayer

func _ready():
	bossAnim.animation_finished.connect(bossAnimFinished)
	
func enter():
	boss.current_attack = await boss.selectAttack()
	anticipation = boss.anticipation_index[boss.current_attack]
	bossAnim.play(anticipation)
	boss.prepareAttackAnimation(boss.current_attack)

func update(delta):
	boss.handlePupils(delta, boss.attack_angle, boss.attack_pos)
	
func bossAnimFinished(anim):
	if boss.stateMachine.current_state == self:
		if "anticipation" in anim:
			emit_signal("transitioned", self, "bossAttack")
		
