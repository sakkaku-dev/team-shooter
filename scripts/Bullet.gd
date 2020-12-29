extends Node2D

export var speed = 500

onready var tail = $Tail

func _ready():
	tail.scale.x = 0


func _physics_process(delta: float):
	move_local_x(speed * delta)
	if tail.scale.x < 1:
		tail.scale.x += 10 * delta


func free_on_hit(body):
	print("Hit")
	queue_free()
