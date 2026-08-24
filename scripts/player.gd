class_name Player
extends CharacterBody3D

@onready var camera := %PlayerCamera as PlayerCamera

@export_category("Jump Settings")
@onready var jump_count = 1

@export_category("Mouse Controls")
@onready var mouse_sensitivity = 0.5
@export var tilt_lower_limit := deg_to_rad(-90.0)
@export var tilt_upper_limit := deg_to_rad(90.0)

var _jumps = 0

var _rotation_input: Vector2
var _mouse_rotation: Vector2

var _player_rotation: Vector3
var _camera_rotation: Vector3

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_jumps = jump_count
	pass

func _unhandled_input(event: InputEvent) -> void:
	var is_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if is_mouse_input:
		var rotation_x = -event.relative.x * mouse_sensitivity
		var rotation_y = -event.relative.y * mouse_sensitivity
		_rotation_input = Vector2(rotation_x, rotation_y)

func _physics_process(delta: float) -> void:
	_active_update(delta)

func _active_update(delta: float) -> void:
	_update_camera(delta)
	pass

func _update_camera(delta: float) -> void:
	var player_rotation := _rotation_input.x * delta
	var camera_rotation := _rotation_input.y * delta
	_mouse_rotation.x += player_rotation
	_mouse_rotation.y += camera_rotation
	_mouse_rotation.y = clamp(_mouse_rotation.y, tilt_lower_limit, tilt_upper_limit)

	_player_rotation = Vector3(0.0, _mouse_rotation.x, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.y, 0.0, 0.0)

	global_transform.basis = Basis.from_euler(_player_rotation)
	camera.transform.basis = Basis.from_euler(_camera_rotation)

	camera.rotation.z = 0.0
	_rotation_input = Vector2.ZERO


func _can_jump() -> bool:
	return is_on_floor() && _jumps > 0
