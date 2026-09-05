class_name SandwormStateChase
extends SandwormState

@export var setting: SandwormStateChaseSetting
var _velocity: Vector3

func state_enter() -> void:
	target_pos = _sandworm.get_head_pos()
	_velocity = Vector3.ZERO

func state_update(delta: float) -> void:
	var player = Services.player
	if player == null:
		return

	target_pos = player.global_position
	#
	# var target_direction := target_pos.direction_to(player.global_position).normalized()
	# var target_velocity := target_direction * setting.max_chase_speed
	# var steering := target_velocity - _velocity
	# steering = steering.limit_length(setting.max_steer_force)
	#
	# _velocity += steering
	# target_pos += _velocity * delta
