extends StageProjectile

var rot_speed := deg_to_rad(10)
var speed : float
@onready var lifetime := 5.0
@onready var timer := $lifetime

func _ready():
	timer.start(lifetime)
	
func initialize(s, f_rad, rad):
	super.initialize(f_rad, rad, "res://Assets/bears/polarbear/polarbear_ball.svg")
	speed = s
	
func handleMovement(delta):
	position = position.rotated(Vector3.UP, speed*delta)
	sprite.rotation.x += rot_speed * sign(speed) * delta

func _on_lifetime_timeout():
	queue_free()
