extends Area2D

export var speed = 500

onready var tail = $Tail

func _ready():
	tail.scale.x = 0


func _physics_process(delta: float):
	move_local_x(speed * delta)
	if tail.scale.x < 1:
		tail.scale.x += 10 * delta


func _on_Bullet_body_entered(body):
	queue_free()


func _on_Timer_timeout():
	queue_free()
