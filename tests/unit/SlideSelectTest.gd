extends SceneTest


func before_each():
	init_scene("res://scripts/SlideSelect.tscn")
	watch_signals(root)
	root.values = ["1", "2", "3", "4"]


func test_value_changed_emit():
	assert_true(root.prev_button.disabled)

	root.next_button_pressed()
	assert_false(root.prev_button.disabled)
	assert_signal_emitted_with_parameters(root, "value_changed", ["2"])

	root.next_button_pressed()
	assert_signal_emitted_with_parameters(root, "value_changed", ["3"])

	root.next_button_pressed()
	assert_true(root.next_button.disabled)
	assert_signal_emitted_with_parameters(root, "value_changed", ["4"])

	root.prev_button_pressed()
	assert_false(root.next_button.disabled)
	assert_signal_emitted_with_parameters(root, "value_changed", ["3"])

	root.prev_button_pressed()
	assert_signal_emitted_with_parameters(root, "value_changed", ["2"])

	root.prev_button_pressed()
	assert_signal_emitted_with_parameters(root, "value_changed", ["1"])


func test_set_value():
	root.set_value("3")

	var visible = null
	for l in root.labels:
		if l.is_visible_in_tree():
			visible = l.text
			break

	assert_eq(visible, "3")
