extends Control

onready var count_label: Label = $ConnectedCount
onready var spawn_button = $Spawn

func _ready():
	if not get_tree().is_network_server():
		spawn_button.hide()

func update_player_count(players: Array) -> void:
	count_label.text = "Connected: " + str(players.size())

