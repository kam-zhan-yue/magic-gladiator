@abstract
class_name Projectile
extends Node3D

@export var alive_time := 2.0

@onready var area_3d := $Area3D as Area3D

var _launch_velocity: Vector3
var _use_gravity: bool

func launch(initial_velocity: Vector3, _gravity: bool = false):
	_launch_velocity = initial_velocity
	_use_gravity = _gravity

	area_3d.body_entered.connect(_body_entered)

func simulate(delta: float) -> void:
	if _use_gravity:
		_launch_velocity += Vector3(0, Global.GRAVITY, 0) * delta
	global_position += _launch_velocity * delta

func _body_entered(body: Node3D) -> void:
	var hit_box = _find_hit_box(body)
	hit(hit_box)
	Projectiles.remove(self)

func _find_hit_box(node: Node3D) -> HitBox:
	if node is HitBox:
		return node as HitBox
	var node_parent = node.get_parent()
	if node_parent:
		return _find_hit_box(node_parent)
	return null

@abstract func hit(hit_box: HitBox) -> void
