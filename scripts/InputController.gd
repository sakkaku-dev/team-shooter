extends Node

func _ready():
	Input.connect("joy_connection_changed", self, "connect_joy_controller")
	

func _unhandled_input(event: InputEvent):
	print(event)
	
	
func connect_joy_controller(dev_id, connected):
	if connected:
		print(dev_id)
	else:
		print(str(dev_id) + ", disconnect")