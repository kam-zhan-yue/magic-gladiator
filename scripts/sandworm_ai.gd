class_name SandwormAI
extends Node3D

@export var target: Node3D
@export var speed := 5.0

@onready var skeleton := %Model/Armature/Skeleton3D as Skeleton3D

var _bone_positions: Array[Vector3] = []
var _bone_lengths: Array[float] = []
var _rest_globals: Array[Transform3D] = []
var _rest_forwards: Array[Vector3] = []

func _ready() -> void:
	await get_tree().process_frame
	_init_chain()

func _init_chain() -> void:
	var bone_count := skeleton.get_bone_count()
	_bone_positions.resize(bone_count)
	_bone_lengths.resize(bone_count)
	_rest_globals.resize(bone_count)
	_rest_forwards.resize(bone_count)

	for i in bone_count:
		_bone_positions[i] = (skeleton.global_transform * skeleton.get_bone_global_pose(i)).origin
		_rest_globals[i] = skeleton.get_bone_global_rest(i)

	for i in bone_count - 1:
		_bone_lengths[i] = _bone_positions[i].distance_to(_bone_positions[i + 1])
		# The natural forward direction of bone i is toward bone i+1 in the rest pose
		_rest_forwards[i] = (_rest_globals[i + 1].origin - _rest_globals[i].origin).normalized()

	if bone_count > 1:
		_bone_lengths[bone_count - 1] = _bone_lengths[bone_count - 2]
		_rest_forwards[bone_count - 1] = _rest_forwards[bone_count - 2]

func _physics_process(delta: float) -> void:
	if _bone_positions.is_empty():
		return
	_update_worm(delta)

func _update_worm(delta: float) -> void:
	var bone_count := skeleton.get_bone_count()
	var head := bone_count - 1

	# Move head toward target
	var to_target := _bone_positions[head].direction_to(target.global_position)
	_bone_positions[head] += to_target * speed * delta

	# Drag each segment to follow, preserving bone length
	for i in range(head - 1, -1, -1):
		var lead := _bone_positions[i + 1]
		var away := _bone_positions[i] - lead
		if away.length_squared() < 0.0001:
			away = Vector3.BACK
		_bone_positions[i] = lead + away.normalized() * _bone_lengths[i]

	# Apply positions and orientations using rest-pose-relative rotation
	var skel_inv := skeleton.global_transform.affine_inverse()

	for i in bone_count:
		var from_skel := skel_inv * _bone_positions[i]
		var look_world := target.global_position if i == head else _bone_positions[i + 1]
		var desired_dir := (skel_inv * look_world - from_skel).normalized()

		var rest_fwd := _rest_forwards[i]
		var new_basis: Basis

		if desired_dir.length_squared() > 0.0001 and rest_fwd.length_squared() > 0.0001:
			var cos_a := clampf(rest_fwd.dot(desired_dir), -1.0, 1.0)
			var q: Quaternion
			if cos_a > 0.9999:
				q = Quaternion.IDENTITY
			elif cos_a < -0.9999:
				# 180-degree case: pick any perpendicular axis
				var perp := rest_fwd.cross(Vector3.UP)
				if perp.length_squared() < 0.001:
					perp = rest_fwd.cross(Vector3.RIGHT)
				q = Quaternion(perp.normalized(), PI)
			else:
				q = Quaternion(rest_fwd, desired_dir)
			new_basis = Basis(q) * _rest_globals[i].basis
		else:
			new_basis = _rest_globals[i].basis

		skeleton.set_bone_global_pose(i, Transform3D(new_basis, from_skel))
