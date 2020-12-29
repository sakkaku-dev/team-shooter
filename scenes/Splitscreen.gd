extends ViewportContainer

onready var viewport = $Viewport
onready var camera = $Viewport/Camera2D

func _input(event):
	# Mouse inputs are not captured by the viewports, using workaround from
	# https://github.com/godotengine/godot/issues/17326#issuecomment-431186323
	if event is InputEventMouse:
		var mouseEvent = event.duplicate()
		mouseEvent.position = get_global_transform().xform_inv(event.global_position)
		viewport.unhandled_input(mouseEvent)
	else:
		viewport.unhandled_input(event)

func track_player(player: Node2D):
	var remote_transform = RemoteTransform2D.new()
	player.add_child(remote_transform)
	print(player.name + ": " + str(player.get_network_master()) + ", " + str(remote_transform.get_network_master()))
	remote_transform.remote_path = remote_transform.get_path_to(camera)
