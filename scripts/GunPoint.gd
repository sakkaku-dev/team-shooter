extends Position2D

class_name GunPoint

export var firerate = 1.0

onready var effect = $Effect
onready var firerate_timer = $Firerate
onready var effect_timer = $EffectTimer

var bullet = preload("res://scenes/Bullet.tscn")
var can_shot = true

func _ready():
	effect.hide()

func shot():
	if not can_shot: return
	
	can_shot = false
	effect.show()
	var b = bullet.instance()
	get_tree().current_scene.add_child(b)
	b.global_position = get_global_transform_with_canvas().origin
	b.global_rotation_degrees = global_rotation_degrees
	firerate_timer.start(firerate)
	effect_timer.start()


func _on_EffectTimer_timeout():
	effect.hide()


func _on_Firerate_timeout():
	can_shot = true
