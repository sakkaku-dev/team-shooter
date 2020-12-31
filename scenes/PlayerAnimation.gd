extends AnimationPlayer

class_name PlayerAnimation

export var sprite_path: NodePath
onready var sprite: Sprite = get_node(sprite_path)

var color: int

func _ready():
	# Animations are shared, so we just create everything beforehand
	# And use the correct animation based on color value
	for c in Player.Team.values():
		_add_animation(c, "Idle", 0, 5, true)
		_add_animation(c, "Run", 5, 11, true)
		_add_animation(c, "Jump", 11, 13, false)
		_add_animation(c, "Crouch", 13, 16, false)
		_add_animation(c, "Died", 16, 24, false)


func _add_animation(c: int, name: String, from: float, to: float, loop: bool) -> void:
	var anim: Animation = get_animation(name).duplicate()
	anim.length = (to - from) * anim.step
	anim.loop = loop

	var track_index = anim.add_track(Animation.TYPE_VALUE)
	var property = "Body/Sprite:frame_coords"
	anim.track_set_path(track_index, property)
	anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)

	for i in range(from, to):
		var time = (i - from) * anim.step
		anim.track_insert_key(track_index, time, Vector2(i, c))

	add_animation(name + str(c), anim)

func idle():
	_play_if_not_already_playing("Idle" + str(color))


func run():
	_play_if_not_already_playing("Run" + str(color))


func jump():
	_play_if_not_already_playing("Jump" + str(color))


func crouch():
	_play_if_not_already_playing("Crouch" + str(color))


func died():
	_play_if_not_already_playing("Died" + str(color))


func _play_if_not_already_playing(anim: String) -> void:
	if assigned_animation != anim:
		play(anim)
