extends Node

class_name Server

signal player_changed(players)

var players = []
var player_scene = preload("res://scenes/Player.tscn")

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _player_connected(id):
	if _is_server():
		rpc_id(id, "_set_players", players)

remote func _set_players(values):
	players = values
	emit_signal("player_changed", players)


func _player_disconnected(id):
	var new_players = []
	for player in players:
		if player["id"] != id:
			new_players.append(player)
	players = new_players


func get_players() -> Array:
	var player_nodes  = []
	for player in players:
		var is_remote = get_tree().get_network_unique_id() != player["id"]
		var input = PlayerInput.new(player["device"], player["joypad"], is_remote)
		var player_node = player_scene.instance()
		player_node.input = input
		player_node.set_network_master(player["id"])
		player_nodes.append(player_node)
	return player_nodes


func _unhandled_input(event: InputEvent):
	if event.is_action("ui_accept"):
		_new_player_from_event(event)


func _new_player_from_event(event: InputEvent):
	var input_event = {"device": event.device, "joypad": _is_joypad_event(event)}
	if _is_server():
		_add_new_player(input_event)
	else:
		rpc_id(1, "_new_client_player", input_event)

func _is_joypad_event(event: InputEvent) -> bool:
	return event is InputEventJoypadButton or event is InputEventJoypadMotion

func _is_server():
	return get_tree().is_network_server()


# Server only functions
remote func _new_client_player(player):
	if _is_server():
		player["id"] = get_tree().get_rpc_sender_id()
		_add_new_player(player)

func _add_new_player(player):
	if not player.has("id"):
		player["id"] = get_tree().get_network_unique_id()
	
	if not _player_exists(player):
		players.append(player)
		emit_signal("player_changed", players)
		rpc("_set_players", players)

func _player_exists(input_event) -> bool:
	for input in players:
		if input["device"] == input_event["device"] and \
			input["joypad"] == input_event["joypad"] and \
			input["id"] == input_event["id"]:
			return true
	return false
