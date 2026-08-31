class_name SandwormBody
extends Node3D

@export var speed := 12.0
@export var distance_constraint := 1.5
@export var num_segments := 10
@export var segment_scene: PackedScene
@export var initial_offset := Vector3(-distance_constraint, 0 ,0)

var _sandworm: Sandworm

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

func get_head() -> Node3D:
	return _segments[0]


func chase(target_pos: Vector3, delta: float) -> void:
	if len(_segments) == 0: 
		return
	var direction = _segments[0].global_position.direction_to(target_pos)
	_move_towards_direction(direction, delta)


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


func _move_towards_direction(direction: Vector3, delta: float) -> void:
	_move(direction, delta)
	_look_at(direction, delta)


func _look_at(direction: Vector3, delta: float) -> void:
	if direction.length() <= 0:
		return
	var target_pos = _segments[0].global_position + speed * direction * delta
	_pull_segment(0, target_pos, delta)

	for i in range(1, _get_total_segments()):
		_pull_segment(i, _segments[i - 1].global_position, delta) 


func _pull_segment_force(index: int, target_pos: Vector3) -> void:
	var current_transform = _segments[index].global_transform
	if current_transform.origin.distance_to(target_pos) <= Global.BASICALLY_ZERO:
		return
	var target_transform = current_transform.looking_at(target_pos)
	_segments[index].global_transform.basis = target_transform.basis


func _pull_segment(index: int, target_pos: Vector3, delta: float) -> void:
	var current_transform = _segments[index].global_transform
	if current_transform.origin.distance_to(target_pos) <= Global.BASICALLY_ZERO:
		return
	var target_transform = current_transform.looking_at(target_pos)
	var weight = 1.0 - exp(-10.0 * delta)
	_segments[index].global_transform.basis = current_transform.basis.slerp(target_transform.basis, weight)


func _move(direction: Vector3, delta: float) -> void:
	_segments[0].global_position += speed * direction * delta
	_pull()


func _pull() -> void:
	for i in range(1, _get_total_segments()):
		var prev = _segments[i - 1].global_position
		var curr = _segments[i].global_position
		var distance = curr.distance_to(prev)
		if distance >= distance_constraint:
			var direction = prev.direction_to(curr)
			var target_pos = prev + direction * distance_constraint
			_segments[i].global_position = target_pos
