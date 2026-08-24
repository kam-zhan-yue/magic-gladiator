class_name Sandworm
extends Node3D

@export var speed := 20.0
@export var distance_constraint := 1.5
@export var num_body_segments := 10
@export var head_scene: PackedScene
@export var body_scene: PackedScene
@export var tail_scene: PackedScene

const BASICALLY_ZERO = 0.001
@export var initial_offset := Vector3(-distance_constraint, 0 ,0)

var segments: Array[Node3D] = []

# ========= Public Methods ============
func init() -> void:
	_add_segment(head_scene.instantiate())
	for i in range(num_body_segments):
		_add_segment(body_scene.instantiate())
	_add_segment(tail_scene.instantiate())

	_init_segments()

func get_head() -> Node3D:
	return segments[0]

func chase(target_pos: Vector3, delta: float) -> void:
	var direction = segments[0].global_position.direction_to(target_pos)
	_move_towards_direction(direction, delta)

# ========= Private Methods ============
func _get_total_segments() -> int:
	return num_body_segments + 2

func _add_segment(segment: Node3D) -> void:
	add_child(segment)
	segments.push_back(segment)
	segment.global_position = global_position + initial_offset * len(segments)

func _init_segments() -> void:
	_pull_segment_force(0, segments[0].global_position - initial_offset)
	for i in range(1, _get_total_segments()):
		_pull_segment_force(i, segments[i - 1].global_position)

# func _process(delta: float) -> void:
# 	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
# 	var direction = Vector3(input_vector.x, -input_vector.y, 0)
# 	_move_towards_direction(direction, delta)


func _move_towards_direction(direction: Vector3, delta: float) -> void:
	_move(direction, delta)
	_look_at(direction, delta)

func _look_at(direction: Vector3, delta: float) -> void:
	if direction.length() <= 0:
		return
	var target_pos = segments[0].global_position + speed * direction * delta
	_pull_segment(0, target_pos, delta)

	for i in range(1, _get_total_segments()):
		_pull_segment(i, segments[i - 1].global_position, delta) 


func _pull_segment_force(index: int, target_pos: Vector3) -> void:
	var current_transform = segments[index].global_transform
	if current_transform.origin.distance_to(target_pos) <= BASICALLY_ZERO:
		return
	var target_transform = current_transform.looking_at(target_pos)
	segments[index].global_transform.basis = target_transform.basis


func _pull_segment(index: int, target_pos: Vector3, delta: float) -> void:
	var current_transform = segments[index].global_transform
	if current_transform.origin.distance_to(target_pos) <= BASICALLY_ZERO:
		return
	var target_transform = current_transform.looking_at(target_pos)
	var weight = 1.0 - exp(-10.0 * delta)
	segments[index].global_transform.basis = current_transform.basis.slerp(target_transform.basis, weight)


func _move(direction: Vector3, delta: float) -> void:
	segments[0].global_position += speed * direction * delta
	_pull()

func _pull() -> void:
	for i in range(1, _get_total_segments()):
		var prev = segments[i - 1].global_position
		var curr = segments[i].global_position
		var distance = curr.distance_to(prev)
		if distance >= distance_constraint:
			var direction = prev.direction_to(curr)
			var target_pos = prev + direction * distance_constraint
			segments[i].global_position = target_pos
