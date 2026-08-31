class_name SandwormController
extends Node3D

@export var sandworm_scene: PackedScene 
@export var chase_setting: SandwormStateChaseSetting
@export var circle_setting: SandwormStateCircleSetting

var _sandworms: Array[Sandworm] = []

func init() -> void:
	var sandworm := _instantiate_sandworm()
	sandworm.init_controller(self)
	sandworm.init_own_segments()
	set_chasing()

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
	set_chasing()


func set_circling() -> void:
	for sandworm in _sandworms:
		var data = SandwormStateCircleData.new()
		data.start_pos = sandworm.get_head().global_position
		data.origin = Vector3.ZERO
		data.setting = circle_setting
		sandworm.brain.circle(data)

func set_chasing() -> void:
	for sandworm in _sandworms:
		var data = SandwormStateChaseData.new()
		data.start_pos = sandworm.get_head().global_position
		data.setting = chase_setting
		sandworm.brain.chase(data)
