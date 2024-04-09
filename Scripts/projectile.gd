extends Node3D
class_name Projectile

@onready var sprite := $projectileSprite
@onready var shadowComp := $shadowComponent
@onready var projHitbox := $projectileHitbox
@onready var projHitboxCol := $projectileHitbox/projectileHitboxCol
var velocity := 0.0
var gravity : float

func initialize(rad, spr, scl, global_pos, vel, grav=0.0):
	projHitboxCol.shape.radius = rad
	shadowComp.max_shadow_radius = rad
	sprite.texture = load(spr)
	var sprite_size = sprite.texture.get_width() * sprite.pixel_size
	var sprite_scale = rad*2.0/sprite_size
	print("%s, %s, %s" % [sprite.texture.get_width(), sprite_size, sprite.get_item_rect().size])
	print(sprite_scale)
	sprite.scale = Vector3(sprite_scale, sprite_scale, 1)
	global_position = global_pos
	velocity = vel
	gravity = grav
	
func _process(delta):
	velocity += gravity * delta
	position.y -= velocity * delta
	#print("IM A PROJECTILE ", position)

func _on_projectile_hitbox_area_entered(area):
	print("AREA ENTERED")
	queue_free()
