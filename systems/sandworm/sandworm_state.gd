@abstract
class_name SandwormState
extends Node3D

var target_pos: Vector3

@abstract func state_enter() -> void
@abstract func state_update(delta: float) -> void
