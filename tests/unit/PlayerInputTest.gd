extends UnitTest

var player_input: PlayerInput


func before_each():
	player_input = autofree(PlayerInput.new())


func test_single_input():
	player_input.handle_input(press_key(PlayerInput.MOVE_LEFT))
	assert_true(player_input.is_pressed([PlayerInput.MOVE_LEFT]))

	player_input.handle_input(release_key(PlayerInput.MOVE_LEFT))
	assert_false(player_input.is_pressed([PlayerInput.MOVE_LEFT]))


func test_multiple_input():
	player_input.handle_input(press_key(PlayerInput.MOVE_LEFT))
	player_input.handle_input(press_key(PlayerInput.JUMP))

	assert_true(player_input.is_pressed([PlayerInput.MOVE_LEFT, PlayerInput.JUMP]))

	player_input.handle_input(release_key(PlayerInput.JUMP))
	assert_false(player_input.is_pressed([PlayerInput.MOVE_LEFT, PlayerInput.JUMP]))
	assert_true(player_input.is_pressed([PlayerInput.MOVE_LEFT]))


func test_move_vector():
	player_input.handle_input(press_key(PlayerInput.MOVE_LEFT, 1))
	assert_eq(player_input.get_move_vector(), Vector2(-1, 0))

	player_input.handle_input(press_key(PlayerInput.MOVE_RIGHT, 1))
	assert_eq(player_input.get_move_vector(), Vector2(0, 0))

	player_input.handle_input(release_key(PlayerInput.MOVE_LEFT))
	assert_eq(player_input.get_move_vector(), Vector2(1, 0))
	

func test_joypad_motion():
	# Joypad can set the action strength of left and right in one event
	var joy = InputEventJoypadMotion.new()
	joy.axis = JOY_AXIS_0
	joy.axis_value = 1
	player_input.handle_input(joy)
	assert_eq(player_input.get_move_vector(), Vector2(1, 0))
	
	joy = InputEventJoypadMotion.new()
	joy.axis_value = -1
	player_input.handle_input(joy)
	assert_eq(player_input.get_move_vector(), Vector2(-1, 0))
