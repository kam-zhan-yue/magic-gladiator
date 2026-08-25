class_name SandwormSegment
extends Node3D

enum Type { Head, Body, Tail }

@onready var hit_box := %HitBox as HitBox

@export var head_model: PackedScene
@export var body_model: PackedScene
@export var tail_model: PackedScene

var _model: Node3D

var _type: Type
var _health: float
var _sandworm: Sandworm
var _segment_index: int

func init(sandworm: Sandworm, index: int, type: Type) -> void:
	_sandworm = sandworm
	_segment_index = index
	_init_model(type)
	hit_box.on_hit.connect(_hit)

func _init_model(type: Type) -> void:
	if _model and _type == type:
		return

	if _model:
		_model.queue_free()
	match _type:
		Type.Head:
			_model = head_model.instantiate()
		Type.Body:
			_model = body_model.instantiate()
		Type.Tail:
			_model = tail_model.instantiate()
	hit_box.add_child(_model)
	_type = type


func _hit(damage: float) -> void:
	_health -= damage
	print("health is now", _health)
	if _health <= 0:
		_sandworm.segment_destroyed(_segment_index)
	else:
		_sandworm.hit(damage, _segment_index)

func uninit() -> void:
	hit_box.on_hit.disconnect(_hit)
