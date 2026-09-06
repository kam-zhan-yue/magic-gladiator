class_name SandwormStateChase
extends SandwormState

@export var setting: SandwormStateChaseSetting

var _velocity: Vector3
var _time := 0.0

func state_enter() -> void:
	target_pos = _sandworm.get_head_pos()
	_velocity = Vector3.ZERO
	_time = 0.0

func state_update(delta: float) -> void:
	_time += delta
	var player = Services.player
	if player == null:
		return

	target_pos = player.global_position


func state_is_finished() -> bool:
	return _time >= setting.chase_time
