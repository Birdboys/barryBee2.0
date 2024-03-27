extends Camera3D
@onready var max_angle := deg_to_rad(20)
@onready var max_offset := 15.0
@onready var trauma := 0.0
@onready var trauma_decrease_rate := 0.75
@export var rot_noise : FastNoiseLite
@export var trans_noise : FastNoiseLite

func _ready():
	rot_noise.seed = 1
	trans_noise.seed = 2
	
func _process(delta):
	print(rot_noise.get_noise_2d(Time.get_ticks_msec(),0))
	trauma -= trauma_decrease_rate * delta
	trauma = max(0, trauma)
	shake(delta)
	#print(trauma, position)
	
func shake(delta):
	var shake_force = pow(trauma, 2.0)
	var shake_angle = max_angle * shake_force * rot_noise.get_noise_2d(Time.get_ticks_msec(),0)
	var shake_offset_x = max_offset * shake_force * trans_noise.get_noise_2d(Time.get_ticks_msec(),0)
	var shake_offset_y = max_offset * shake_force * trans_noise.get_noise_2d(Time.get_ticks_msec(),5)
	rotation.z = shake_angle
	position = Vector3(shake_offset_x, shake_offset_y, 0.0) * get_parent().basis

func changeTrauma(amount):
	trauma += amount
