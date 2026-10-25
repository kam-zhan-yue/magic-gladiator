class_name AbilityController
extends Node3D

@export var primary: Ability

var _player: Player
var _inited := false

var _primary_requested = false

func init() -> void:
	_inited = true
	_player = Services.player
	primary.init(_player);

func _is_active() -> bool:
	return _inited

func _input(event: InputEvent) -> void:
	if not _is_active(): return
	if event.is_action_pressed("primary"):
		_primary_requested = true


func _process(delta: float) -> void:
	if not _is_active(): return
	primary.update_timer(delta)

	primary.ability_update(delta)

	if _primary_requested:
		_primary_requested = false
		if primary.is_cooldown_over() and primary.ability_can_cast():
			primary.ability_cast()
			# primary.reset_cooldown()
