extends AnimationPlayer

class_name PlayerAnimation

enum Team {
	BLACK,
	BLUE,
	GREEN,
	RED,
	YELLOW,
}

export var sprite_path: NodePath
onready var sprite: Sprite = get_node(sprite_path)

export (Team) var team_color = Team.BLACK


func _ready():
	_add_animation("Idle", 0, 5, true)
	_add_animation("Run", 5, 11, true)
	_add_animation("Jump", 11, 13, false)
	_add_animation("Crouch", 13, 16, false)
	_add_animation("Died", 16, 24, false)


func _add_animation(name: String, from: float, to: float, loop: bool) -> void:
	var anim = get_animation(name)
	anim.length = (to - from) * anim.step
	anim.loop = loop

	var track_index = anim.add_track(Animation.TYPE_VALUE)
	var property = "Body/Sprite:frame_coords"
	anim.track_set_path(track_index, property)
	anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)

	for i in range(from, to):
		var time = (i - from) * anim.step
		anim.track_insert_key(track_index, time, Vector2(i, team_color))


func idle():
	_play_if_not_already_playing("Idle")


func run():
	_play_if_not_already_playing("Run")


func jump():
	_play_if_not_already_playing("Jump")


func crouch():
	_play_if_not_already_playing("Crouch")


func died():
	_play_if_not_already_playing("Died")


func _play_if_not_already_playing(anim: String) -> void:
	if assigned_animation != anim:
		play(anim)
