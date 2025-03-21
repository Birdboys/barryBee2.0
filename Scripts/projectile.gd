extends Node3D
class_name Projectile

@onready var sprite := $projectileSprite
@onready var shadowComp := $shadowComponent
@onready var projHitbox := $projectileHitbox
@onready var projHitboxCol := $projectileHitbox/projectileHitboxCol
var velocity := 0.0
var gravity : float

func initialize(rad, spr, vel, grav=0.0):
	projHitboxCol.shape.radius = rad
	shadowComp.max_shadow_radius = rad
	sprite.texture = load(spr)
	var sprite_size = sprite.texture.get_width() * sprite.pixel_size
	var sprite_scale = rad*2.0/sprite_size
	sprite.scale = Vector3(sprite_scale, sprite_scale, 1)
	velocity = vel
	gravity = grav
	
func _process(delta):
	velocity += gravity * delta
	position.y -= velocity * delta


func _on_projectile_hitbox_body_entered(body):
	queue_free()
	pass # Replace with function body.
