extends KinematicBody2D

class_name Player

enum Team {
	BLACK,
	BLUE,
	GREEN,
	RED,
	YELLOW,
}

export var speed = 200
export var acceleration = 800
export var friction = 1600
export var jump_force = 800

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * ProjectSettings.get_setting("physics/2d/default_gravity_vector")
onready var body := $Body
onready var animation := $AnimationPlayer
onready var gun := $Body/GunPoint

var input: PlayerInput
var velocity = Vector2.ZERO
var motion = Vector2.ZERO
var is_crouching = false
var is_dead = false
var team_color = Team.BLACK

puppet var puppet_motion = Vector2.ZERO
puppet var puppet_pos = Vector2.ZERO

# TODO: make sure everything is in sync

func _ready():
	animation.color = team_color

func set_color(color: String):
	team_color = Team.get(color)


func _accept_input() -> bool:
	return is_network_master() and not is_dead


func _unhandled_input(event: InputEvent):
	if _accept_input():
		input.handle_input(event)
	

func _process(delta: float):
	if _accept_input():
		if input.is_pressed([PlayerInput.ATTACK]):
			rpc_unreliable("_shot")
			
		if is_on_floor() and input.is_pressed([PlayerInput.CROUCH]):
			rpc_unreliable("_crouch", true)
		elif is_crouching:
			rpc_unreliable("_crouch", false)

sync func _shot():
	gun.shot()

sync func _crouch(value: bool):
	is_crouching = value

func _physics_process(delta: float):
	if is_dead:
		if not is_on_floor():
			velocity += gravity
			velocity = move_and_slide(velocity, Vector2.UP)
			animation.jump()
		else:
			animation.died()
		return
	
	if is_network_master():
		motion = input.get_move_vector()
		rset_unreliable("puppet_motion", motion)
		rset_unreliable("puppet_pos", global_position)
	else:
		motion = puppet_motion
		global_position = puppet_pos
		
	var is_moving = motion.length() > 0.01

	var accel = acceleration if is_moving else friction
	velocity = velocity.move_toward(motion * speed, accel * delta)
	
	if is_moving:
		body.scale.x = motion.normalized().x

	velocity += gravity

	if not is_on_floor():
		animation.jump()
	
	if is_crouching:
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


func _on_Health_zero_health():
	rpc("die")

sync func die():
	is_dead = true
