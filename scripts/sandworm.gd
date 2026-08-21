class_name Sandworm
extends Node3D

@export var speed := 20
@export var distance_constraint := 2
@export var num_body_segments := 10
@export var head_scene: PackedScene
@export var body_scene: PackedScene
@export var tail_scene: PackedScene

var TOTAL_SEGMENTS = num_body_segments + 2

var segments: Array[Node3D] = []

func _ready() -> void:
	_add_segment(head_scene.instantiate())
	for i in range(num_body_segments):
		_add_segment(body_scene.instantiate())
	_add_segment(tail_scene.instantiate())

func _add_segment(segment: Node3D) -> void:
	add_child(segment)
	segment.global_position = global_position
	segments.push_back(segment)

func _process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector3(input_vector.x, -input_vector.y, 0)
	_move(direction, delta)


func _move(direction: Vector3, delta: float) -> void:
	segments[0].global_position += speed * direction * delta
	_pull()


func _pull() -> void:
	for i in range(1, TOTAL_SEGMENTS):
		var prev = segments[i - 1].global_position
		var curr = segments[i].global_position
		var distance = curr.distance_to(prev)
		if distance >= distance_constraint:
			var direction = prev.direction_to(curr)
			var target_pos = prev + direction * distance_constraint
			segments[i].global_position = target_pos
