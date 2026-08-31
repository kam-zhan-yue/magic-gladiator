class_name SandwormController
extends Node3D

@export var sandworm_scene: PackedScene 
@onready var target := %SandwormTarget as Node3D
@onready var radius := 15.0
@onready var frequency := 2.0

@onready var y_radius := 2.0
@onready var y_frequency := 5.0

var _sandworms: Array[Sandworm] = []

var _time = 0.0

func init() -> void:
	var sandworm := _instantiate_sandworm()
	sandworm.init_controller(self)
	sandworm.init_own_segments()
	target.global_position = sandworm.get_head().global_position

func _instantiate_sandworm() -> Sandworm:
	var sandworm := sandworm_scene.instantiate() as Sandworm
	add_child(sandworm)
	_sandworms.push_back(sandworm)
	return sandworm

func _process(delta: float) -> void:
	_time += delta

	var target_pos = target.global_position
	target_pos.x = cos(_time * frequency) * radius
	target_pos.y = sin(_time * y_frequency) * y_radius
	target_pos.z = sin(_time * frequency) * radius
	target.global_position = target_pos

	for sandworm in _sandworms:
		sandworm.chase(target_pos, delta)

func split(segments: Array[SandwormSegment]) -> void:
	var sandworm := _instantiate_sandworm()
	sandworm.init_controller(self)
	sandworm.init_with_segments(segments)
