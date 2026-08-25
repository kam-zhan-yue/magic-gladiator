class_name SpellCaster
extends Node3D

@export var initial_spell: Spell

@onready var orb := %Orb as CSGSphere3D
@onready var spells := %Spells

var _player: Player
var _inited := false

var _active_spell: int
var _spells: Array[Spell] = []
var _spell_requested: bool

func init(player: Player) -> void:
	_inited = true
	_player = player
	for child in spells.get_children():
		if child is Spell:
			_spells.push_back(child as Spell)

	for spell in _spells:
		spell.init(player)

func _is_active() -> bool:
	return _inited and len(_spells) > 0

func _input(event: InputEvent) -> void:
	if not _is_active(): return
	if event.is_action_pressed("shoot"):
		_spell_requested = true
	elif event.is_action_pressed("cycle_backward"):
		_cycle_backward()
	elif event.is_action_pressed("cycle_backward"):
		_cycle_forward()


func _process(delta: float) -> void:
	if not _is_active(): return
	var active_spell = _spells[_active_spell]

	for spell in _spells:
		active_spell.update_timer(delta)

	active_spell.spell_update(delta)

	if _spell_requested:
		_spell_requested = false
		if active_spell.is_cooldown_over() and active_spell.spell_can_cast():
			active_spell.spell_cast()
			active_spell.reset_cooldown()

func _cycle_forward() -> void:
	if _active_spell + 1 >= len(_spells):
		set_active_spell(0)
	else:
		set_active_spell(_active_spell + 1)

func _cycle_backward() -> void:
	if _active_spell - 1 < 0:
		set_active_spell(len(_spells) - 1)
	else:
		set_active_spell(_active_spell - 1)

func set_active_spell(index: int) -> void:
	if index < 0 or index >= len(_spells):
		return
	_active_spell = index
	_set_orb_color(_spells[_active_spell].orb_color)

func _set_orb_color(color: Color) -> void:
	orb.material.albedo_color = color
