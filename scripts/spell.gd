@abstract
class_name Spell
extends Node3D

@abstract func update(delta: float) -> void
@abstract func can_cast() -> bool
@abstract func cast() -> void
