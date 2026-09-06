class_name SandwormStateCircle
extends SandwormState

@export var setting: SandwormStateCircleSetting

var _origin: Vector3
var _time := 0.0
var _angle := 0.0

func state_enter() -> void:
	_time = 0.0
	_origin = Vector3.ZERO

	var start_pos := _sandworm.get_head_pos()
	_angle = atan2(start_pos.x, start_pos.z)
	_set_target_pos()

func state_update(delta: float) -> void:
	_time += delta

	_angle += setting.angular_speed * delta
	_set_target_pos()


func _set_target_pos() -> void:
	target_pos.y = setting.y_pos
	target_pos.x = sin(_angle) * setting.radius
	target_pos.z = cos(_angle) * setting.radius

func state_is_finished() -> bool:
	return _time >= setting.circle_time
