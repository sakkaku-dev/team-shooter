extends Node

onready var server := $Server
onready var network := $GlobalUI/NetworkContainer
onready var main_screen := $Screens/MainScreen
onready var screens := $Screens

var splitscreen = preload("res://scenes/Splitscreen.tscn")

func start_game():
	if get_tree().is_network_server():
		rpc("spawn_players")

remotesync func spawn_players():
	network.hide()
	
	var current_screen = main_screen
	
	for player in server.get_players():
		main_screen.add_node(player)
		if get_tree().get_network_unique_id() == player.get_network_master():
			if current_screen == null:
				current_screen = splitscreen.instance()
				screens.add_child(current_screen)
				current_screen.viewport.world_2d = main_screen.viewport.world_2d
			
			current_screen.track_player(player)
			current_screen = null
	
	screens.show()
