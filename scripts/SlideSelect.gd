extends Control

signal value_changed(value)

export var values: Array setget _set_values

onready var labels = $Labels
onready var next_button = $NextButton
onready var prev_button = $PrevButton

var active_label: int setget _set_active_label


func set_value(value):
	_set_active_label(values.find(value), false)


func show_buttons():
	next_button.show()
	prev_button.show()


func hide_buttons():
	next_button.hide()
	prev_button.hide()


func _set_values(v):
	if v:
		values = v

	if labels == null:
		return

	for c in labels.get_children():
		labels.remove_child(c)

	for value in values:
		var label = Label.new()
		label.text = value
		labels.add_child(label)
	
	_set_active_label(0, false)

func _set_active_label(idx: int, emit = true):
	active_label = idx
	_update_labels(emit)


func _update_labels(emit = true):
	for c in labels.get_children():
		c.hide()

	labels.get_child(active_label).show()

	prev_button.disabled = false
	next_button.disabled = false

	if active_label == 0:
		prev_button.disabled = true

	if active_label >= values.size() - 1:
		next_button.disabled = true

	if emit:
		emit_signal("value_changed", values[active_label])


func next_button_pressed():
	self.active_label += 1


func prev_button_pressed():
	self.active_label -= 1
