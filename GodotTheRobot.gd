extends CharacterBody2D

@export var SPEED = 300.0
var SLIDE_BOOST = 500
var GROUND_ACCELERATION = SPEED*7
var AIR_ACCELERATION = SPEED*6
@export var JUMP_VELOCITY = -400.0
var BOUNCE_VELOCITY = -1000.0
var SLIDE_FRICTION = 300
var RUN_FRICTION = 700
var AIR_FRICTION = 200
var target_velocity = Vector2(0,0)

var friction = RUN_FRICTION
var acceleration =0

var grounded = false
var jump_pressed = false
var sliding = false

var flipx = 1
var walk_tweener = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree

func _ready():
	#animation_player.set_default_blend_time(.2)
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if grounded:
			grounded = false
	
	if !grounded and is_on_floor():
		grounded = true
		jump_pressed = false
		#animation_player.play("on_land")
	
	if grounded and Input.is_action_just_pressed("ui_down"):
		sliding = true
		#animation_player.play("sliding")
	 
	if sliding and Input.is_action_just_released("ui_down"):
		sliding = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_pressed = true
		velocity.y = JUMP_VELOCITY
		#animation_player.play("jump")
	
	if Input.is_action_just_released("ui_accept") and jump_pressed and velocity.y < 0:
		velocity.y=0
		jump_pressed = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !grounded:
		friction = AIR_FRICTION
		acceleration = AIR_ACCELERATION
	else:
		acceleration = GROUND_ACCELERATION
		if sliding:
			friction = SLIDE_FRICTION
		else:
			friction = RUN_FRICTION
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if sign(velocity.x) != direction and grounded:
			velocity.x = 0
		if abs(velocity.x) > SPEED and sign(velocity.x) == direction:
			velocity.x = move_toward(velocity.x,SPEED*direction,friction*delta)
		else:
			velocity.x = move_toward(velocity.x,SPEED*direction, acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction*delta)
	
	#if velocity.x != 0 and is_on_floor():
		#if velocity.x > 0:
			#animation_player.play("walk_r")
		#else:
			#animation_player.play("walk_l")
	#else:
		#if animation_player.current_animation != "idle":
			#animation_player.play("idle")

	move_and_slide()
	update_anim_parameters(delta)

func update_anim_parameters(delta):
	if Input.get_axis("ui_left", "ui_right") == 0:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false
	elif !sliding:
		animation_tree["parameters/conditions/moving"] = true
		animation_tree["parameters/conditions/idle"] = false
	print(Input.get_axis("ui_left", "ui_right"))
	print(walk_tweener)
	walk_tweener = move_toward(walk_tweener,Input.get_axis("ui_left", "ui_right"),4*delta)
	animation_tree["parameters/walk/blend_position"] = walk_tweener
	animation_tree["parameters/falling/blend_position"] = walk_tweener#Input.get_axis("ui_left", "ui_right")#velocity.x
	
	animation_tree["parameters/conditions/sliding"] = sliding
	animation_tree["parameters/conditions/on_land"] = grounded
	animation_tree["parameters/conditions/jump"] = jump_pressed
	animation_tree["parameters/conditions/falling"] = !grounded

func _on_red_enemy_hitbox_body_entered(body):
	if body == self:
		get_tree().reload_current_scene()
	#then send to spawn


func _on_bounce_pad_body_entered(body):
	if body == self:
		velocity.y = BOUNCE_VELOCITY
		#animation_player.play("bouncepad_launch")
		print("bounce")
