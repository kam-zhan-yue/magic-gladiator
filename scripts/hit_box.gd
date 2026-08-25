class_name HitBox
extends PhysicsBody3D

signal on_hit(damage: float)

func hit(damage: float):
	on_hit.emit(damage)
