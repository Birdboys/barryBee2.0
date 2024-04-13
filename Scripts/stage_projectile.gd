extends Node3D
class_name StageProjectile

@onready var sprite := $projectileSprite
@onready var projHitbox := $projectileHitbox
@onready var projHitboxCol := $projectileHitbox/projectileHitboxCol
var field_rad : float

func initialize(f_rad, rad, spr):
	field_rad = f_rad
	projHitboxCol.shape.radius = rad
	sprite.texture = load(spr)
	var sprite_size = sprite.texture.get_width() * sprite.pixel_size
	var sprite_scale = rad*2.0/sprite_size
	sprite.scale = Vector3(sprite_scale, sprite_scale, 1)
	
func _process(delta):
	handleMovement(delta)
	sprite.look_at(Vector3(0, position.y, 0))
	
func handleMovement(delta):
	pass
	
