class_name AbilityFirePunchEffect
extends Node3D

@export var damage_lifetime := 0.2
@export var effect_lifetime := 1.0

@onready var damage_area := %DamageArea as DamageArea

func play(damage: float) -> void:
	print("Playing with damage %d" % damage)
	damage_area.init(damage)
	play_damage()
	play_effect()

func play_damage() -> void:
	await Global.wait_seconds(damage_lifetime)
	damage_area.queue_free()

func play_effect() -> void:
	await Global.wait_seconds(effect_lifetime)
	queue_free()
