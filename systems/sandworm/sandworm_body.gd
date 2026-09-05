class_name SandwormBody
extends Node3D

@export var speed := 12.0
@export var steer_speed := 5.0
@export var distance_constraint := 1.5
@export var num_segments := 10
@export var segment_scene: PackedScene
@export var initial_offset := Vector3(-distance_constraint, 0 ,0)
@export var y_frequency := 5.0
@export var y_amplitude := 3.0

var _sandworm: Sandworm
var _head: Vector3
var _velocity: Vector3
var _time := 0.0

var _segments: Array[SandwormSegment] = []

# ========= Public Methods ============
func init_sandworm(sandworm: Sandworm) -> void:
	_sandworm = sandworm

func init_own_segments() -> void:
	var segments = _spawn_segments()
	init_with_segments(segments)

func init_with_segments(segments: Array[SandwormSegment]) -> void:
	_segments = segments
	for i in range(len(_segments)):
		if i == 0:
			_segments[i].init(self, i, SandwormSegment.Type.Head)
		elif i == len(_segments) - 1:
			_segments[i].init(self, i, SandwormSegment.Type.Tail)
		else:
			_segments[i].init(self, i, SandwormSegment.Type.Body)
	_reset_segment_positions()
	_head = _segments[0].global_position


func update(target_pos: Vector3, delta: float) -> void:
	if len(_segments) == 0: 
		return
	_time += delta
	_move_towards_position(target_pos, delta)


func hit(_damage: float, _segment: int) -> void:
	pass


func segment_destroyed(index: int) -> void:
	for segment in _segments:
		segment.uninit()

	var segment = _segments[index]
	segment.queue_free()

	var head_segments := _segments.slice(0, index)
	var tail_segments := _segments.slice(index + 1, len(_segments))

	# Split the head!
	init_with_segments(head_segments)

	# Split the tail!
	_sandworm.split(tail_segments)

func get_head_pos() -> Vector3:
	return _head

# ========= Private Methods ============
func _get_total_segments() -> int:
	return len(_segments)


func _spawn_segments() -> Array[SandwormSegment]:
	var segments: Array[SandwormSegment] = []
	for i in range(num_segments):
		var segment = segment_scene.instantiate() as SandwormSegment
		add_child(segment)
		segment.global_position = global_position + initial_offset * len(_segments)
		segments.push_back(segment)
	return segments


func _reset_segment_positions() -> void:
	if len(_segments) == 0:
		return
	_pull_segment_force(0, _segments[0].global_position - initial_offset)
	for i in range(1, _get_total_segments()):
		_pull_segment_force(i, _segments[i - 1].global_position)


func _move_towards_position(target_pos: Vector3, delta: float) -> void:
	var target_direction := _head.direction_to(target_pos).normalized()
	var target_velocity := target_direction * speed
	var steering := target_velocity - _velocity
	steering = steering.limit_length(steer_speed)

	_velocity += steering
	_head += _velocity * delta

	var animated_head := _get_animated_head_pos()
	var head_transform = _segments[0].global_transform
	head_transform.basis = _get_look_at(head_transform, animated_head, delta)
	head_transform.origin = animated_head
	_segments[0].global_transform = head_transform

	_pull(delta)


func _get_animated_head_pos() -> Vector3:
	var target_pos = _head
	target_pos.y += sin(_time * y_frequency) * y_amplitude
	return target_pos


func _pull(delta: float) -> void:
	for i in range(1, _get_total_segments()):
		_pull_segment(i, _segments[i - 1].global_position, delta) 


func _pull_segment_force(index: int, target_pos: Vector3) -> void:
	var current_transform = _segments[index].global_transform
	if current_transform.origin.distance_to(target_pos) <= Global.BASICALLY_ZERO:
		return
	var target_transform = current_transform.looking_at(target_pos)
	_segments[index].global_transform.basis = target_transform.basis
	_segments[index].global_transform.origin = target_pos


func _pull_segment(index: int, target_pos: Vector3, delta: float) -> void:
	var current_transform = _segments[index].global_transform
	_segments[index].global_transform.origin = _get_constraint(current_transform, target_pos)
	_segments[index].global_transform.basis = _get_look_at(current_transform, target_pos, delta)

func _get_constraint(current_transform: Transform3D, target_pos: Vector3) -> Vector3:
	var distance = current_transform.origin.distance_to(target_pos)
	if distance >= distance_constraint:
		var direction = target_pos.direction_to(current_transform.origin)
		return target_pos + direction * distance_constraint
	return current_transform.origin

func _get_look_at(current_transform: Transform3D, target_pos: Vector3, delta: float) -> Basis:
	if current_transform.origin.distance_to(target_pos) > Global.BASICALLY_ZERO:
		var target_transform = current_transform.looking_at(target_pos)
		var weight = 1.0 - exp(-10.0 * delta)
		return current_transform.basis.slerp(target_transform.basis, weight)
	return current_transform.basis
