class_name HitBox
extends Node3D

signal on_hit(damage: float)

func hit(damage: float):
	on_hit.emit(damage)
