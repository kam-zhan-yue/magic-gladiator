class_name SandwormSegment
extends Node3D

var _health: float
var _sandworm: Sandworm
var _segment_index: int

func init(sandworm: Sandworm, index: int) -> void:
	_sandworm = sandworm
	_segment_index = index
	_setup_hitbox(self, true)

func _hit(damage: float) -> void:
	_health -= damage
	print("health is now", _health)
	if _health <= 0:
		_sandworm.segment_destroyed(_segment_index)
	_sandworm.hit(damage, _segment_index)

func uninit() -> void:
	_setup_hitbox(self, false)

func _setup_hitbox(node: Node3D, attach: bool) -> void:
	for child in node.get_children():
		if child is HitBox:
			if attach:
				child.on_hit.connect(_hit)
			else:
				child.on_hit.disconnect(_hit)
		else:
			_setup_hitbox(child, attach)
