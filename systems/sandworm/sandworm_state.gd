@abstract
class_name SandwormState
extends Node3D

var target_pos: Vector3
var _sandworm: Sandworm

func state_init(sandworm: Sandworm) -> void:
	_sandworm = sandworm

@abstract func state_enter() -> void
@abstract func state_update(delta: float) -> void
