extends Control

onready var count_label: Label = $ConnectedCount
onready var spawn_button = $Spawn

func update_player_count(players: Array) -> void:
	count_label.text = "Connected: " + str(players.size())


func show():
	.show()
	if not get_tree().is_network_server():
		spawn_button.hide()
