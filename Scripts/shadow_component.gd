extends Node3D

@export var max_shadow_radius : float
@export var casting_shadow := false
@export var max_shadow_dist := 25.0
@export var scale_size := false
@onready var shadowRay := $shadowRay
@onready var shadowSprite := $shadowSprite
func _ready():
	shadowSprite.mesh.size = Vector2(max_shadow_radius, max_shadow_radius)*2
	shadowRay.target_position = Vector3(0,-max_shadow_dist, 0)
func _process(delta):
	shadowSprite.visible = false
	if casting_shadow:
		if shadowRay.is_colliding():
			var collision_point = shadowRay.get_collision_point()
			var collision_distance = shadowRay.global_position.distance_to(collision_point)
			var remap_distance = collision_distance/max_shadow_dist
			if  collision_distance < max_shadow_dist:
				shadowSprite.visible = true
				shadowSprite.mesh.size = Vector2(max_shadow_radius, max_shadow_radius) * 2 #* (1-remap(collision_distance, 0.0, max_shadow_dist, 0.5, 1))
				shadowSprite.mesh.material.albedo_color = Color(Color.WHITE, 0.9-remap_distance/2.0)
				shadowSprite.global_position = collision_point + Vector3.UP * 0.1
				if scale_size:
					shadowSprite.mesh.size = (0.9-remap_distance/2.0) * Vector2(max_shadow_radius, max_shadow_radius)*2

func toggleShadow(on):
	casting_shadow = on
	shadowRay.enabled = on
