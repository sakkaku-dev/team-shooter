extends Node

class_name PlayerInput

export var joypad_input = false
export var device_id = 0

const MOVE_LEFT := "move_left"
const MOVE_RIGHT := "move_right"
const JUMP := "jump"
const ATTACK := "attack"
const CROUCH := "crouch"

const input_types = [MOVE_RIGHT, MOVE_LEFT, JUMP, ATTACK, CROUCH]

var inputs = []

var action_strength = {
	MOVE_LEFT: 0,
	MOVE_RIGHT: 0,
}


func _init(event: InputEvent = null):
	if event != null:
		joypad_input = _is_joypad_event(event)
		device_id = event.device


func is_player_event(event: InputEvent) -> bool:
	return joypad_input == _is_joypad_event(event) and device_id == event.device


func _should_handle_event(event: InputEvent) -> bool:
	if event.device == device_id and joypad_input and _is_joypad_event(event):
		return true
	
	if event.device == device_id and not joypad_input and not _is_joypad_event(event):
		return true
	
	return false


func _is_joypad_event(event: InputEvent) -> bool:
	return event is InputEventJoypadButton or event is InputEventJoypadMotion


func handle_input(event: InputEvent) -> void:
	if not _should_handle_event(event):
		return
	
	_update_action_strength(event)
	
	var action = _get_action_for_event(event)
	if action == "":
		return

	# TODO: handle joypad move events
	if event.is_action_pressed(action) and not inputs.has(action):
		inputs.append(action)
	if event.is_action_released(action) and inputs.has(action):
		inputs.erase(action)


func _update_action_strength(event: InputEvent) -> void:
	for k in action_strength.keys():
		if event.is_action(k):
			action_strength[k] = event.get_action_strength(k)


func _get_action_for_event(event: InputEvent) -> String:
	for action in input_types:
		if event.is_action(action):
			return action

	return ""


func is_pressed(keys: Array) -> bool:
	for k in keys:
		if not inputs.has(k):
			return false
	return true


func get_move_vector() -> Vector2:
	return Vector2(action_strength[MOVE_RIGHT] - action_strength[MOVE_LEFT], 0)
