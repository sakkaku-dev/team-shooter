extends Control

const SERVER_PORT = 25252
const MAX_PLAYERS = 4

onready var server_ip = $JoinContainer/Server

func start_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	_set_network(peer)

func connect_server():
	var peer = NetworkedMultiplayerENet.new()
	var ip = server_ip.text if server_ip.text != "" else "localhost"
	peer.create_client(ip, SERVER_PORT)
	_set_network(peer)

func _set_network(peer):
	get_tree().network_peer = peer
	get_tree().change_scene("res://scenes/Game.tscn")
