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
	player_input.joypad_input = true
	
	# Joypad can set the action strength of left and right in one event
	player_input.handle_input(joypad_motion_event(JOY_AXIS_0, 1))
	assert_eq(player_input.get_move_vector(), Vector2(1, 0))
	
	player_input.handle_input(joypad_motion_event(JOY_AXIS_0, -1))
	assert_eq(player_input.get_move_vector(), Vector2(-1, 0))
	

func test_ignore_joypad_if_disabled():
	player_input.joypad_input = false
	
	player_input.handle_input(press_key(PlayerInput.MOVE_LEFT, 1))
	assert_eq(player_input.get_move_vector(), Vector2(-1, 0))
	
	player_input.handle_input(joypad_motion_event(JOY_AXIS_0, 1))
	assert_eq(player_input.get_move_vector(), Vector2(-1, 0))


func test_only_read_joypad_if_enabled():
	player_input.joypad_input = true
	
	player_input.handle_input(joypad_motion_event(JOY_AXIS_0, 1))
	assert_eq(player_input.get_move_vector(), Vector2(1, 0))
	
	player_input.handle_input(press_key(PlayerInput.MOVE_LEFT, 1))
	assert_eq(player_input.get_move_vector(), Vector2(1, 0))
