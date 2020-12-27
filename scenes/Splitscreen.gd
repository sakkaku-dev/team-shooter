extends ViewportContainer

onready var viewport = $Viewport
onready var camera = $Viewport/Camera2D

func add_node(node: Node2D):
	viewport.add_child(node)

func track_player(player: Node2D):
	var remote_transform = RemoteTransform2D.new()
	player.add_child(remote_transform)
	remote_transform.remote_path = remote_transform.get_path_to(camera)
