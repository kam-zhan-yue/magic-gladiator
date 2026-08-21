class_name SandwormV1
extends Node3D
@export var target: Node3D
@export var speed := 5.0

@onready var skeleton := %Model/Armature/Skeleton3D as Skeleton3D

# var _bone_positions: Array[Vector3] = []
# var _bone_lengths: Array[float] = []
# var _rest_globals: Array[Transform3D] = []
# var _rest_forwards: Array[Vector3] = []

func _process(delta: float) -> void:
	var bone_count := skeleton.get_bone_count()
	var root_bone := skeleton.get_bone_global_pose(0)
	var head_bone := skeleton.get_bone_global_pose(bone_count - 1)

	root_bone = skeleton.global_transform * root_bone
	head_bone = skeleton.global_transform * head_bone

	# print("Head", head_bone.origin)	
	# print("Target", target.global_position)
	#  print(head_bone.origin.distance_to(target.global_position))
	if head_bone.origin.distance_to(target.global_position) > 1:
		var next_bone := skeleton.get_bone_global_pose(1)
		next_bone = skeleton.global_transform * next_bone

		var direction_to_move := root_bone.origin.direction_to(next_bone.origin)
		root_bone.origin = root_bone.origin + direction_to_move * delta * speed

		var final_transform := skeleton.global_transform.affine_inverse() * root_bone
		skeleton.set_bone_global_pose(0, final_transform)

	pass
