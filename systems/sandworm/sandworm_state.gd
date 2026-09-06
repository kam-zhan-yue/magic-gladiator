@abstract
class_name SandwormState
extends Node3D

@export var state: SandwormBrain.State

var target_pos: Vector3
var _sandworm: Sandworm

func state_init(sandworm: Sandworm) -> void:
	_sandworm = sandworm

@abstract func state_enter() -> void
@abstract func state_update(delta: float) -> void
@abstract func state_is_finished() -> bool
