extends Node3D
@onready var fieldHole := $levelRing/hole
@onready var fieldPlatform := $levelRing/platform
@onready var bee := $beeCharacter
@onready var field_radius := 15.0
@onready var field_segments := 24
@onready var field_platform_length := 1.0
@onready var bee_radius := field_radius-(field_platform_length/2.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	setField(field_radius, field_segments, field_platform_length)
	placeBee(15)
	bee.position.y = 2

func setField(radius, segments, platform_length=1):
	fieldPlatform.radius = radius
	fieldPlatform.sides = segments
	fieldHole.radius = radius - platform_length
	fieldHole.sides = segments

func placeBee(deg):
	bee.position = Vector3.FORWARD.rotated(Vector3.UP, deg_to_rad(deg)) * bee_radius
