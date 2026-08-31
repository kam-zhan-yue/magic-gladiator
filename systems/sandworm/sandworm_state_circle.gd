class_name SandwormStateCircle
extends SandwormState

var _data: SandwormStateCircleData
var _setting: SandwormStateCircleSetting
var _time := 0.0

func set_data(data: SandwormStateCircleData) -> void:
	_data = data
	_setting = data.setting

func state_enter() -> void:
	_time = 0.0
	target_pos = _data.start_pos

func state_update(delta: float) -> void:
	_time += delta

	target_pos.x = _data.origin.x + cos(_time * _setting.xz_frequency) * _setting.xz_radius
	target_pos.y = _data.origin.y + sin(_time * _setting.y_frequency) * _setting.y_radius
	target_pos.z = _data.origin.z + sin(_time * _setting.xz_frequency) * _setting.xz_radius
