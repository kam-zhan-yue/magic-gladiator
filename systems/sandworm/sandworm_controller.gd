class_name SandwormController
extends Node3D

@export var sandworm_scene: PackedScene 
@export var circle_setting: SandwormStateCircleSetting

var _sandworms: Array[Sandworm] = []

func init() -> void:
	var sandworm := _instantiate_sandworm()
	sandworm.init_controller(self)
	sandworm.init_own_segments()

	var circle_data = SandwormStateCircleData.new()
	circle_data.start_pos = Vector3.ZERO
	circle_data.origin = Vector3.ZERO
	circle_data.setting = circle_setting
	sandworm.brain.state_circle(circle_data)

func _instantiate_sandworm() -> Sandworm:
	var sandworm := sandworm_scene.instantiate() as Sandworm
	add_child(sandworm)
	_sandworms.push_back(sandworm)
	return sandworm

func _process(delta: float) -> void:
	for sandworm in _sandworms:
		sandworm.update(delta)

func split(segments: Array[SandwormSegment]) -> void:
	var sandworm := _instantiate_sandworm()
	sandworm.init_controller(self)
	sandworm.init_with_segments(segments)

	var circle_data = SandwormStateCircleData.new()
	circle_data.start_pos = Vector3.ZERO
	circle_data.origin = Vector3.ZERO
	circle_data.setting = circle_setting
	sandworm.brain.state_circle(circle_data)
