@tool
class_name KrakenTentacleBody
extends Node3D

@export var num_segments := 10
@export var distance_constraint := 1.0
@export var angle_constraint := 10.0
@export var wave_amplitude := 2.5
@export var wave_frequency := 2.0
@export var wave_speed := 3.0

@onready var segment_holder := %Segments as Node3D

var _time := 0.0
var _tentacle_segments: Array[KrakenTentacleSegment] = []
var _fabrik_segments: Array[FabrikSegment] = []

func init() -> void:
	print("Inited Tentacle Segments")
	var tentacle_segments: Array[KrakenTentacleSegment] = []
	var fabrik_segments: Array[FabrikSegment] = []

	for i in segment_holder.get_child_count():
		var segment := segment_holder.get_child(i) as KrakenTentacleSegment
		tentacle_segments.append(segment)
		var fabrik := FabrikSegment.new()
		fabrik.position = segment.global_position
		fabrik.distance_constraint = distance_constraint
		if i == segment_holder.get_child_count() - 1:
			fabrik.length = 1.0
		else:
			var next_segment := segment_holder.get_child(i+1)
			fabrik.length = next_segment.global_position.distance_to(fabrik.position)
		fabrik_segments.append(fabrik)

	_tentacle_segments = tentacle_segments
	_fabrik_segments = fabrik_segments
	_time = 0.0


func update(target_pos: Vector3, delta: float) -> void:
	_time += delta
	if target_pos == Vector3.ZERO:
		return
	if len(_fabrik_segments) == 0:
		init()
	var solver := FabrikSolver.new()
	solver.solve(target_pos, global_position, _fabrik_segments)
	# _apply_wave(delta)
	_update_tentacle()


func _apply_wave(delta: float) -> void:
	_time += delta

	var total_length := 0.0
	var segment_lengths: Array[float] = []
	for i in range(len(_fabrik_segments) - 1):
		var curr := _fabrik_segments[i].position
		var next := _fabrik_segments[i+1].position
		var length = curr.distance_to(next)
		segment_lengths.append(length)
		total_length += length

	var accumulated_length := 0.0
	for i in range(1, len(_fabrik_segments)):
		accumulated_length += segment_lengths[i-1]
		var t := accumulated_length / total_length

		var vec := _fabrik_segments[i].position - _fabrik_segments[i-1].position
		var direction := vec.normalized()
		var perpendicular := direction.cross(Vector3.UP)
		var wave_phase := _time * wave_speed + t * wave_frequency * TAU
		var wave_offset := sin(wave_phase) * wave_amplitude
		_fabrik_segments[i].position += perpendicular * wave_offset

func _update_tentacle() -> void:
	for i in range(len(_fabrik_segments)):
		_tentacle_segments[i].global_position = _fabrik_segments[i].position
