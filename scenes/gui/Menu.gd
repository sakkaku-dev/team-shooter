extends Control

const SERVER_PORT = 25252
const MAX_PLAYERS = 4

onready var server_ip = $JoinContainer/Server

func _ready():
	get_tree().connect("connected_to_server", self, "_change_to_game")


func _change_to_game():
	get_tree().change_scene("res://scenes/Game.tscn")


func start_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	_change_to_game()

func connect_server():
	var peer = NetworkedMultiplayerENet.new()
	var ip = server_ip.text if server_ip.text != "" else "localhost"
	peer.create_client(ip, SERVER_PORT)
	get_tree().network_peer = peer
