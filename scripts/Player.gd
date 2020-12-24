extends KinematicBody2D

class_name Player

export var speed = 300
export var acceleration = 1000
export var friction = 1600
export var jump_force = 1000

onready var input = $PlayerInput
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * ProjectSettings.get_setting("physics/2d/default_gravity_vector")
onready var body = $Body
onready var animation: PlayerAnimation = $AnimationPlayer

var velocity = Vector2.ZERO

func _unhandled_input(event: InputEvent):
	input.handle_input(event)

func _physics_process(delta: float):
	var motion = input.get_move_vector()
	var is_moving = motion.length() > 0.01

	var accel = acceleration if is_moving else friction
	velocity = velocity.move_toward(motion * speed, accel * delta)
	
	if is_moving:
		body.scale.x = motion.normalized().x

	velocity += gravity
	if not is_on_floor():
		animation.jump()
	
	if is_on_floor() and input.is_pressed([PlayerInput.CROUCH]):
		animation.crouch()
	else:
		if is_on_floor():
			if input.is_pressed([PlayerInput.JUMP]):
				velocity.y = -jump_force
				animation.jump()
			elif abs(velocity.x) > 0.01:
				animation.run()
			else:
				animation.idle()
		velocity = move_and_slide(velocity, Vector2.UP)
