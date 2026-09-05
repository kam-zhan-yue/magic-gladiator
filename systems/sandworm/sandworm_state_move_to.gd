class_name SandwormStateMoveTo
extends SandwormState

const THRESHOLD = 1.0
var _time := 0.0

func state_enter() -> void:
	_time = 0.0
	var checkpoints = Services.sandworm.checkpoints
	var rand = randi_range(0, len(checkpoints) - 1)
	target_pos = checkpoints[rand].global_position

func state_update(delta: float) -> void:
	_time += delta

func is_finished() -> bool:
	var sandworm_pos = _sandworm.get_head_pos()
	return sandworm_pos.distance_to(target_pos) <= THRESHOLD
