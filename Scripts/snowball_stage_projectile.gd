extends StageProjectile

var speed : float

func initialize(s, f_rad, rad):
	super.initialize(f_rad, rad, "res://Assets/bears/polarbear/polarbear_ball.svg")
	speed = s
	
func handleMovement(delta):
	position = position.rotated(Vector3.UP, speed*delta)
	
