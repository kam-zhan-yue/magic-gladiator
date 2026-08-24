class_name SpellCaster
extends Node3D

@onready var orb := %Orb as CSGSphere3D
@export var initial_spell: Spell
var _active_spell: Spell

var _spell_requested: bool

func _ready() -> void:
	_active_spell = initial_spell

func _input(event: InputEvent) -> void:
	if not _active_spell: return
	if event.is_action_pressed("shoot"):
		_spell_requested = true


func _process(delta: float) -> void:
	_active_spell.update(delta)
	if _spell_requested:
		_spell_requested = false
		if _active_spell.can_cast():
			_active_spell.cast()
