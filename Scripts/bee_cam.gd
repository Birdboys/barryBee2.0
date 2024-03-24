extends Camera3D
@onready var cam_offset := Vector3(0,5,15)
@onready var max_angle := deg_to_rad(15)
@onready var max_offset := 10.0
@onready var trauma := 0.3
@onready var trauma_decrease_rate := 0.5
@onready var rot_noise := FastNoiseLite.new()
@onready var trans_noise := FastNoiseLite.new()

func _ready():
	rot_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	trans_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	rot_noise.seed = 1
	trans_noise.seed = 2
	#rot_noise.frequency = 8
	#trans_noise.frequency = 8
	
func _process(delta):
	trauma -= trauma_decrease_rate * delta
	trauma = max(0, trauma)
	#shake(delta)
	#print(trauma, position)
func shake(delta):
	var shake_force = pow(trauma, 3)
	var shake_angle = max_angle * shake_force * rot_noise.get_noise_2d(delta,0)
	var shake_offset_x = max_offset * shake_force * trans_noise.get_noise_2d(delta,0)
	var shake_offset_y = max_offset * shake_force * trans_noise.get_noise_2d(delta,5)
	rotation.z = shake_angle
	position = Vector3(shake_offset_x, shake_offset_y, 0.0) * basis
	
func remapNoise(n):
	return remap(n, 0.0,1.0,-1.0,1.0)

func changeTrauma(amount):
	trauma += amount
