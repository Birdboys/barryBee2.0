extends BossState

@onready var boss_follow_angle := deg_to_rad(30)
@onready var boss_follow_speed := 0.02
@export var idle_time_min := 1.5
@export var idle_time_max := 3.0
@export var idleTimer : Timer

func _ready():
	idleTimer.timeout.connect(idleTimerDone)
	
func enter():
	boss.bossAnim.play("idle")
	idleTimer.start(randf_range(idle_time_min, idle_time_max))

func update(delta):
	if abs(angle_difference(boss.rotation.y, boss.bee_angle)) > boss_follow_angle:
		boss.rotation.y = lerp_angle(boss.rotation.y, boss.bee_angle - boss_follow_angle * sign(angle_difference(boss.rotation.y, boss.bee_angle)), boss_follow_speed)
	boss.handlePupils(delta, boss.bee_angle, boss.bee_pos)
	
func idleTimerDone():
	emit_signal("transitioned",self,"bossAnticipation")

