extends Node2D

onready var server := $Server
onready var network := $CanvasLayer/NetworkContainer

func start_game():
	if get_tree().is_network_server():
		rpc("spawn_players")

remotesync func spawn_players():
	network.hide()
	for player in server.get_players():
		add_child(player)
