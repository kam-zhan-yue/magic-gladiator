class_name SandwormBrain
extends Node3D

@onready var state_circling := %Circle as SandwormStateCircle
@onready var state_chase := %Chase as SandwormStateChase
@onready var debug_ball := %CircleDebugBall as Node3D

enum State { None, Circling, Chasing }

var _state := State.None
var _current_state: SandwormState

func init() -> void:
	pass

func update(delta: float) -> void:
	if _state == State.None or _current_state == null: return

	_current_state.state_update(delta)
	debug_ball.global_position = get_body_pos()

func circle(data: SandwormStateCircleData) -> void:
	state_circling.set_data(data)
	enter_state(State.Circling)

func chase(data: SandwormStateChaseData) -> void:
	state_chase.set_data(data)
	enter_state(State.Chasing)

func enter_state(state: State) -> void:
	_state = state
	if state == State.None:
		_current_state = null
		return

	if state == State.Circling:
		_current_state = state_circling
	elif state == State.Chasing:
		_current_state = state_chase
	
	_current_state.state_enter()

func get_body_pos() -> Vector3:
	if _current_state == null:
		return Vector3.ZERO
	return _current_state.target_pos
