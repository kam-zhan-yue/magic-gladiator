class_name SandwormStateMoveTo
extends SandwormState

var _time := 0.0

func state_enter() -> void:
	_time = 0.0
	# target_pos = _data.start_pos

func state_update(delta: float) -> void:
	_time += delta

func is_finished() -> bool:
	return true
