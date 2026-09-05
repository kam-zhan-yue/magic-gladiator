class_name SandwormBrain
extends Node3D

@export var chase_time := 1.0
@export var circle_time := 10.0
@onready var state_circling := %Circle as SandwormStateCircle
@onready var state_chase := %Chase as SandwormStateChase
@onready var state_move_to := %MoveTo as SandwormStateMoveTo
@onready var debug_ball := %CircleDebugBall as Node3D

enum State { None, Circling, Chasing, MoveTo }

var _state := State.None
var _current_state: SandwormState
var _timer := 0.0


func init_sandworm(sandworm: Sandworm) -> void:
	state_circling.state_init(sandworm)
	state_chase.state_init(sandworm)
	state_move_to.state_init(sandworm)


func update(delta: float) -> void:
	_check_state(delta)
	_update_state(delta)


func _check_state(delta: float) -> void:
	_timer += delta
	if _state == State.None:
		enter_state(State.Circling)
	elif _state == State.Circling and _timer >= circle_time:
		enter_state(State.MoveTo)
	elif _state == State.MoveTo and state_move_to.is_finished():
		enter_state(State.Chasing)
	elif _state == State.Chasing and _timer >= chase_time:
		enter_state(State.Circling)


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

	if state == State.Circling:
		_current_state = state_circling
	elif state == State.Chasing:
		_current_state = state_chase
	elif state == State.MoveTo:
		_current_state = state_move_to
	
	_current_state.state_enter()


func get_body_pos() -> Vector3:
	if _current_state == null:
		return Vector3.ZERO
	return _current_state.target_pos
