extends Node

onready var player_select := $GlobalUI/PlayerSelect
onready var player_select_manager := $GlobalUI/PlayerSelect/PlayerSelectManager
onready var main_screen := $Screens/MainScreen
onready var screens := $Screens

var splitscreen = preload("res://scenes/Splitscreen.tscn")

func start_game():
	if get_tree().is_network_server():
		rpc("spawn_players")

remotesync func spawn_players():
	player_select.hide()
	
	var current_screen = main_screen
	
	for player in player_select_manager.get_players():
		var id = player.get_network_master()
		player.name = player.input.get_unique_name()
		main_screen.viewport.add_child(player, true)
		
		if get_tree().get_network_unique_id() == player.get_network_master():
			if current_screen == null:
				current_screen = splitscreen.instance()
				screens.add_child(current_screen)
				current_screen.viewport.world_2d = main_screen.viewport.world_2d

			current_screen.track_player(player)
			current_screen = null
	
	screens.show()
