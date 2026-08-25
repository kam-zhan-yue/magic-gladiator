@abstract
class_name Spell
extends Node3D

@export var cooldown_time := 0.2
@export var orb_color: Color

var _player: Player
var _timer = 0

func init(player: Player) -> void:
	_player = player
	_timer = 0

func update_timer(delta: float) -> void:
	if _timer > 0:
		_timer -= delta

func is_cooldown_over() -> bool:
	return _timer <= 0

func reset_cooldown() -> void:
	_timer = cooldown_time

@abstract func spell_update(delta: float) -> void
@abstract func spell_can_cast() -> bool
@abstract func spell_cast() -> void
