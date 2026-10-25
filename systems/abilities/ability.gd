@abstract
class_name Ability
extends Node3D

@export var cooldown_time := 0.2

var _player: Player
var _cooldown_timer = 0

func init(player: Player) -> void:
	_player = player
	_cooldown_timer = 0

func update_timer(delta: float) -> void:
	if _cooldown_timer > 0:
		_cooldown_timer -= delta

func is_cooldown_over() -> bool:
	return _cooldown_timer <= 0

func reset_cooldown() -> void:
	_cooldown_timer = cooldown_time

@abstract func ability_update(delta: float) -> void
@abstract func ability_can_cast() -> bool
@abstract func ability_cast() -> void
