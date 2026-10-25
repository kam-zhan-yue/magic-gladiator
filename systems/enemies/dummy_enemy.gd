class_name DummyEnemy
extends Node3D

@export var health := 100.0

var _dead := false

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0 and !_dead:
		_die()

func _die() -> void:
	_dead = true
	queue_free()
