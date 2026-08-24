class_name Player
extends CharacterBody3D

@onready var camera := %PlayerCamera as PlayerCamera

@export_category("Movement Settings")
@export var speed := 10.0
@export var acceleration := 100.0
@export var deceleration := 10.0


@export_category("Jump Settings")
@export var gravity = -10.0
@onready var jump_count = 1

@export_category("Mouse Controls")
@onready var mouse_sensitivity = 0.5
@export var tilt_lower_limit := deg_to_rad(-90.0)
@export var tilt_upper_limit := deg_to_rad(90.0)

var _jumps = 0
var _jump_requested: bool

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
	if event.is_action_pressed("move_jump"):
		_jump_requested = true

func _physics_process(delta: float) -> void:
	_active_update(delta)

func _active_update(delta: float) -> void:
	_update_camera(delta)
	_update_body(delta)
	move_and_slide()

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

func _update_body(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3(0, gravity, 0) * delta

	# Handle Jumping
	if _jump_requested:
		_jump_requested = false
		_jump()
	
	# Handle Movement
	var input_dir = Global.get_movement_input()
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	if direction:
		var moving_speed = Vector2(velocity.x, velocity.z).length()
		if moving_speed < speed:
			velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
			velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction.x * speed, deceleration * delta)
			velocity.z = move_toward(velocity.z, direction.z * speed, deceleration * delta)
		pass
	else:
		if is_on_floor():
			velocity.x = 0
			velocity.z = 0
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration * delta)
			velocity.z = move_toward(velocity.z, 0, deceleration * delta)

func _jump() -> void:
	pass

func _can_jump() -> bool:
	return is_on_floor() && _jumps > 0
