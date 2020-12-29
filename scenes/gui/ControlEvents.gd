extends Control

signal back

export var hide_on_ready = true

func _ready():
	if hide_on_ready:
		hide()

func _input(event):
	if event.is_action("ui_cancel") and is_visible_in_tree():
		hide()
		emit_signal("back")
