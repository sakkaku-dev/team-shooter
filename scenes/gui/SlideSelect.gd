extends Control

signal value_changed(value)

export var values: Array

onready var labels = $Labels
onready var next_button = $NextButton
onready var prev_button = $PrevButton

var active_label = 0

func _ready():
	for value in values:
		var label = Label.new()
		label.text = value
		labels.add_child(label)
	
	update_labels()


func update_labels():
	for c in labels.get_children():
		c.hide()
	
	labels.get_child(active_label).show()
	
	if active_label == 0:
		prev_button.hide()
	else:
		prev_button.show()
	
	if active_label >= values.size() - 1:
		next_button.hide()
	else:
		next_button.show()
		
	emit_signal("value_changed", values[active_label])


func _on_NextButton_pressed():
	active_label += 1
	update_labels()


func _on_PrevButton_pressed():
	active_label -= 1
	update_labels()
