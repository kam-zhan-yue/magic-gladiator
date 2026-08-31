class_name SandwormStateChase
extends SandwormState

var _data: SandwormStateChaseData
var _setting: SandwormStateChaseSetting
var _velocity: Vector3

func set_data(data: SandwormStateChaseData) -> void:
	_data = data
	_setting = data.setting

func state_enter() -> void:
	target_pos = _data.start_pos
	_velocity = Vector3.ZERO

func state_update(delta: float) -> void:
	var player = Services.player
	if player == null:
		return

	var target_direction := target_pos.direction_to(player.global_position).normalized()
	var target_velocity := target_direction * _setting.max_chase_speed
	var steering := target_velocity - _velocity
	steering = steering.limit_length(_setting.max_steer_force)

	_velocity += steering
	target_pos += _velocity * delta
