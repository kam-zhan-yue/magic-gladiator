class_name Sandworm
extends Node3D

@export var target := Node3D

@export var speed := 5.0
@onready var skeleton := %Model/Armature/Skeleton3D as Skeleton3D

var segments := []

func _ready() -> void:
	# for i in range(bone_count):
	# 	var bone_pos := skeleton.get_bone_pose(i)
	# 	print("Bone %d is %s" % [i, foo.global_position])
	pass

func _process(delta: float) -> void:
	var bone_count = skeleton.get_bone_count()

	# _look_at(bone_count - 1)
	_move_to(bone_count - 1, delta)


func _look_at(bone_index: int) -> void:
	var bone_pos := skeleton.global_transform * skeleton.get_bone_global_pose(bone_index)
	bone_pos = bone_pos.looking_at(target.global_position, Vector3(1, 0, 0))
	bone_pos = skeleton.global_transform.affine_inverse() * bone_pos
	skeleton.set_bone_global_pose(bone_index, bone_pos)

func _move_to(bone_index: int, delta: float) -> void:
	var bone_pos := skeleton.global_transform * skeleton.get_bone_global_pose(bone_index)
	var translation = bone_pos.origin.direction_to(target.global_position) * speed * delta
	bone_pos = bone_pos.translated(translation)
	bone_pos = skeleton.global_transform.affine_inverse() * bone_pos
	skeleton.set_bone_global_pose(bone_index, bone_pos)
