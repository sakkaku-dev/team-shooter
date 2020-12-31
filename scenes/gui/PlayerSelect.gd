extends Control

class_name PlayerSelect

onready var team_select := $MarginContainer/VBoxContainer/TeamSelect
onready var team_color := $MarginContainer/VBoxContainer/TeamColor
onready var team_container := $MarginContainer/VBoxContainer
onready var join_key = $MarginContainer/JoinKey

var team: String setget _set_team_color
var device = 0
var joypad = false
var _player_set = false

func _ready():
	team_select.values = Player.Team.keys()
	if team_select.values.size() > 0:
		self.team = team_select.values[0]


func reset():
	set_network_master(1)
	_player_set = false
	team_container.hide()
	join_key.show()
	team_select.hide_buttons()


func new_player_from_data(data: Dictionary):
	_apply_player_data(data)
	_player_set = true
	team_container.show()
	join_key.hide()
	if is_network_master():
		team_select.show_buttons()


func _set_team_color(color: String):
	team = color
	team_select.set_value(color)
	
	for c in team_color.get_children():
		c.hide()
	
	var node = team_color.get_node(team)
	if node:
		node.show()


func _on_TeamSelect_value_changed(value):
	self.team = value
	rpc("_update_team_color", value)


remote func _update_team_color(value: String):
	team_select.set_value(value)
	self.team = value


func has_player_set() -> bool:
	return _player_set


func _apply_player_data(data: Dictionary):
	set_network_master(data["id"])
	device = data["device"]
	joypad = data["joypad"]
	if data.has("color"):
		self.team = data["color"]

func to_player_data() -> Dictionary:
	var data = {
		"id": get_network_master(),
		"device": device,
		"joypad": joypad,
		"color": team
	}
	
	return data
