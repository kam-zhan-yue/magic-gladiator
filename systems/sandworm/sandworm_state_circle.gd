class_name SandwormStateCircle
extends SandwormState

@export var setting: SandwormStateCircleSetting

var _origin: Vector3
var _time := 0.0

func state_enter() -> void:
	_time = 0.0
	_origin = Vector3.ZERO
	target_pos = _sandworm.get_head_pos()
	target_pos.y = setting.y_pos

func state_update(delta: float) -> void:
	_time += delta

	target_pos.x = _origin.x + cos(_time * setting.xz_frequency) * setting.xz_radius
	target_pos.y = setting.y_pos
	target_pos.z = _origin.z + sin(_time * setting.xz_frequency) * setting.xz_radius
