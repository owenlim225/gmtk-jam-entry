extends CharacterBody2D

@onready var player = $"."
@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

const MOTION_SPEED = 150 # Pixels/second.
var last_direction = Vector2(1, 0)
var is_small = false

var normal_size = Vector2(1, 1)
var big_size = Vector2(2, 2)
var normal_collision_shape = Vector2(1, 1)
var small_collision_shape = Vector2(2, 2)

func _physics_process(_delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	motion.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	
	# Set the velocity and move
	velocity = motion
	move_and_slide()

	var dir = velocity

	if dir.length() > 0:
		last_direction = dir
		animation.play("Run")
		
		# Flip the sprite based on direction
		if dir.x < 0:
			animation.flip_h = true
		elif dir.x > 0:
			animation.flip_h = false
	else:
		animation.play("Idle")
	
	# Change size on input
	if Input.is_action_just_pressed("changeSize"):
		if is_small:
			shrink_player()
		else:
			grow_player()

func grow_player():
	animation.scale = big_size
	collision.shape.radius = small_collision_shape
	is_small = true

func shrink_player():
	animation.scale = normal_size
	collision.shape.radius = normal_collision_shape

	is_small = false

