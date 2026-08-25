class_name SandwormSegment
extends Node3D

enum Type { Head, Body, Tail }

@onready var hit_box := %HitBox as HitBox

@export var head_model: PackedScene
@export var body_model: PackedScene
@export var tail_model: PackedScene

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
	if hit_box.get_child_count() > 0 and _type == type:
		return

	for child in hit_box.get_children():
		child.queue_free()

	var model := _instantiate_model(type)
	hit_box.add_child(model)
	_type = type

func _instantiate_model(type: Type) -> Node3D:
	match type:
		Type.Head:
			return head_model.instantiate()
		Type.Body:
			return body_model.instantiate()
		Type.Tail:
			return tail_model.instantiate()
		_:
			return body_model.instantiate()


func _hit(damage: float) -> void:
	_health -= damage
	if _health <= 0:
		_sandworm.segment_destroyed(_segment_index)
	else:
		_sandworm.hit(damage, _segment_index)

func uninit() -> void:
	hit_box.on_hit.disconnect(_hit)
