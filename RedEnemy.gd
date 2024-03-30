extends CharacterBody2D


const SPEED = 300.0
var motion = Vector2( )
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

func _physics_process(delta):
	motion.y += gravity
	motion.x += SPEED * direction

	move_and_slide()
