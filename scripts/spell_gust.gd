class_name SpellGust
extends Spell

@export var jump_speed := 10.0

func spell_update(_delta: float) -> void:
	pass

func spell_can_cast() -> bool:
	return true

func spell_cast() -> void:
	_player.velocity.y = jump_speed
