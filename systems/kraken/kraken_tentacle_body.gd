@tool
class_name KrakenTentacleBody
extends Node3D

@export var num_segments := 10
@export var distance_constraint := 1.0
@export var angle_constraint := 10.0
@export var segment_scene: PackedScene
@export var wave_amplitude := 2.5
@export var wave_frequency := 2.0
@export var wave_speed := 3.0

@onready var segment_holder := %Segments as Node3D

var _time := 0.0
var _segments: Array[KrakenTentacleSegment] = []

func init() -> void:
	for child in segment_holder.get_children():
		if child is KrakenTentacleSegment:
			var segment = child as KrakenTentacleSegment
			_segments.append(segment)

	if len(_segments) == 0:
		_init_segments()

	_time = 0.0

func _init_segments() -> void:
	for i in range(num_segments):
		var segment := segment_scene.instantiate()
		add_child(segment)
		segment.global_position = global_position
		_segments.append(segment)

func update(target_pos: Vector3, delta: float) -> void:
	_time += delta
	if target_pos == Vector3.ZERO:
		return
	if len(_segments) == 0:
		init()
	_fabrik(target_pos)

func _fabrik(target_pos: Vector3) -> void:
	_process_forwards(target_pos)
	_process_backwards()

func _process_forwards(target_pos: Vector3) -> void:
	_segments[-1].global_position = target_pos
	for i in range(len(_segments) - 2, -1, -1):
		var curr_node := _segments[i+1]
		var next_node := _segments[i]
		_calculate_constraint(curr_node, next_node)


func _process_backwards() -> void:
	_segments[0].global_position = global_position
	for i in range(1, len(_segments)):
		var curr_node := _segments[i-1]
		var next_node := _segments[i]
		_calculate_constraint(curr_node, next_node)

func _calculate_constraint(curr: KrakenTentacleSegment, next: KrakenTentacleSegment) -> void:
	var next_position := next.global_position
	var curr_position := curr.global_position
	var difference := next_position - curr_position

	if difference.length() >= distance_constraint:
		var new_position := curr_position + difference.normalized() * distance_constraint
		next.global_position = new_position
	else:
		next.global_position = curr_position + difference

func _apply_wave(delta: float) -> void:
	_time += delta

	var total_length := 0.0
	for i in range(len(_segments) - 1):
		var curr := _segments[i].global_position
		var next := _segments[i+1].global_position
		total_length += curr.distance_to(next)

	var accumulated_length := 0.0
	# for i in rangg

	pass
