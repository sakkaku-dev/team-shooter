extends MarginContainer

onready var team_select := $VBoxContainer/TeamSelect

var team = PlayerAnimation.Team.BLACK

func _ready():
	team_select.values = PlayerAnimation.Team.values()


func _on_TeamSelect_value_changed(value):
	team = PlayerAnimation.Team.get(value)
