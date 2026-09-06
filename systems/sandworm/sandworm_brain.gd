class_name SandwormBrain
extends Node3D

@onready var debug_ball := %CircleDebugBall as Node3D

@export var state_order: Array[State]

enum State { None, Circling, Chasing, MoveTo }

var _state := State.None
var _states: Dictionary[State, SandwormState]
var _current_state: SandwormState
var _timer := 0.0

var _state_index := 0


func init_sandworm(sandworm: Sandworm) -> void:
	for child in get_children():
		if child is SandwormState:
			var sandworm_state := child as SandwormState
			_states[sandworm_state.state] = sandworm_state
			sandworm_state.state_init(sandworm)


func update(delta: float) -> void:
	_check_state(delta)
	_update_state(delta)


func _check_state(delta: float) -> void:
	_timer += delta
	if _state == State.None:
		_state_index = 0
		enter_state(state_order[_state_index])
	elif _current_state.state_is_finished():
		_progress_state()


func _progress_state() -> void:
	_state_index += 1
	if _state_index >= len(state_order):
		_state_index = 0
	enter_state(state_order[_state_index])

func _update_state(delta: float) -> void:
	if _current_state != null:
		_current_state.state_update(delta)
	debug_ball.global_position = get_body_pos()


func enter_state(state: State) -> void:
	print("Entering ", State.keys()[state])
	_state = state
	_timer = 0.0
	if state == State.None:
		_current_state = null
		return

	if state not in _states:
		print("Couldn't find %s in states", State.keys()[state])
		return

	_current_state = _states[state]
	_current_state.state_enter()


func get_body_pos() -> Vector3:
	if _current_state == null:
		return Vector3.ZERO
	return _current_state.target_pos
