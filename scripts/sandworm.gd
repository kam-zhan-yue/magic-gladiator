class_name Sandworm
extends Node3D

@export var num_segments := 10
@export var body_scene: PackedScene

@onready var skeleton := %Model/Armature/Skeleton3D as Skeleton3D

var segments := []

func _ready() -> void:
	# var bone_count = skeleton.get_bone_count()
	# for i in range(bone_count):
	# 	var bone_pos := skeleton.get_bone_pose(i)
	# 	print("Bone %d is %s" % [i, foo.global_position])
	pass

func _process(delta: float) -> void:
	var root_bone := skeleton.get_bone_pose(0)
	var root_pos := root_bone.origin
	root_pos.x += delta * 5.0
	skeleton.set_bone_pose_position(0, root_pos)

	pass
