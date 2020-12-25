extends Node

var player_inputs = []

onready var count_label: Label = $CenterContainer/VBoxContainer/ConnectedCount

var player_scene = preload("res://scenes/Player.tscn")

func _ready():
	_update_count()


func _unhandled_input(event: InputEvent):
	if event.is_action("ui_accept"):
		if not _player_input_exist(event):
			player_inputs.append(PlayerInput.new(event))
			_update_count()


func _player_input_exist(event: InputEvent) -> bool:
	for input in player_inputs:
		if input.is_player_event(event):
			return true
	return false


func _update_count() -> void:
	count_label.text = "Connected: " + str(player_inputs.size())


func on_start():
	for input in player_inputs:
		var player = player_scene.instance()
		player.input = input
		get_tree().current_scene.add_child(player)
	queue_free()
