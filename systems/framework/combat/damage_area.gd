class_name DamageArea
extends Area3D

var _damage: float

func init(damage: float) -> void:
	_damage = damage
	body_entered.connect(_body_entered)
	pass

func _body_entered(body: Node3D) -> void:
	print("Body Entered: ", body.name)
	if body is DummyEnemy:
		print("Damaged %s for %d" % [body.name, _damage])
		var enemy := body as DummyEnemy
		enemy.take_damage(_damage)
