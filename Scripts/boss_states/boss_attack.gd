extends BossState

@export var bossAnim : AnimationPlayer
var attack : String
func _ready():
	bossAnim.animation_finished.connect(bossAttackFinished)
	
func enter():
	attack = boss.current_attack
	boss.bossAnim.play(attack)
	
func update(delta):
	boss.handlePupils(delta, boss.attack_angle, boss.attack_pos)

func exit():
	boss.resetHitbox()
	boss.resetHurtbox()
	
func bossAttackFinished(anim):
	if boss.stateMachine.current_state == self:
		if "attack" in anim:
			emit_signal("transitioned", self, "bossRecovery")

func handleBeeInterrupt():
	print("INTERRUPT DURING", attack)
	boss.interrupted = true
	if attack in boss.finishers:
		emit_signal("transitioned", self, "bossDefeated")
		print("IM FUCKING DEAD HOLY SHIT")
		boss.emit_signal("boss_defeated")
	else:
		boss.emit_signal("change_progress", 5.0)
		emit_signal("transitioned", self, "bossRecovery")
