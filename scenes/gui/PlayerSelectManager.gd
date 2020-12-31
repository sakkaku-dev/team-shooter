extends Control

onready var spawn_button = $Spawn
onready var player_selects = $PlayerSelects

const player_scene = preload("res://scenes/Player.tscn")

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	if not get_tree().is_network_server():
		spawn_button.hide()

func _player_connected(id):
	if get_tree().is_network_server():
		rpc_id(id, "_set_players", get_players_data())

remote func _set_players(values):
	update_players(values)

func _player_disconnected(id):
	var new_players = []
	for player in get_players_data():
		if player["id"] != id:
			new_players.append(player)
	update_players(new_players)

func get_players_data() -> Array:
	var data = []
	for node in player_selects.get_children():
		var slot = node as PlayerSelect
		if slot.has_player_set():
			data.append(slot.to_player_data())
	return data

func update_players(values):
	for c in player_selects.get_children():
		c.reset()
	
	for player in values:
		_add_new_player(player)


func _add_new_player(player):
	var slot = _get_next_free_slot() as PlayerSelect
	if slot:
		slot.new_player_from_data(player)
	else:
		print("No free slot")

func _get_next_free_slot() -> Node:
	for child in player_selects.get_children():
		if not child.has_player_set():
			return child
	return null


func _is_player_full() -> bool:
	return _get_next_free_slot() == null


func get_players() -> Array:
	var player_nodes  = []
	var players = get_players_data()
	for i in range(players.size()):
		var player = players[i]
		var input = _to_player_input(player)
		var player_node = player_scene.instance(PackedScene.GEN_EDIT_STATE_MAIN)
		var color = player["color"]
		player_node.set_color(color)
		player_node.input = input
		player_node.set_network_master(player["id"])
		player_nodes.append(player_node)
	return player_nodes


func _to_player_input(player):
	var is_remote = get_tree().get_network_unique_id() != player["id"]
	var input = PlayerInput.new(player["device"], player["joypad"], is_remote)
	input.set_network_master(player["id"])
	return input


func _unhandled_input(event: InputEvent):
	if event is InputEventJoypadButton or event is InputEventKey:
		_new_player_from_event(event)

func _new_player_from_event(event: InputEvent):
	var input_event = {"device": event.device, "joypad": _is_joypad_event(event)}
	if get_tree().is_network_server():
		_append_new_player_if_possible(input_event)
	else:
		rpc_id(1, "_new_client_player", input_event)

func _is_joypad_event(event: InputEvent) -> bool:
	return event is InputEventJoypadButton or event is InputEventJoypadMotion


# Server only functions
remote func _new_client_player(player):
	if get_tree().is_network_server():
		player["id"] = get_tree().get_rpc_sender_id()
		_append_new_player_if_possible(player)

func _append_new_player_if_possible(player):
	if _is_player_full():
		print("Max players")
		return
	
	if not player.has("id"):
		player["id"] = get_tree().get_network_unique_id()
	
	if not _player_exists(player):
		print(player)
		rpc("_append_player", player)

remotesync func _append_player(player):
	_add_new_player(player)

func _player_exists(input_event) -> bool:
	for input in get_players_data():
		if input["device"] == input_event["device"] and \
			input["joypad"] == input_event["joypad"] and \
			input["id"] == input_event["id"]:
			return true
	return false
