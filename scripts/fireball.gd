class_name Fireball
extends Projectile

var _damage: float

func shoot(damage: float, launch_velocity: Vector3) -> void:
	launch(launch_velocity)
	_damage = damage

func hit(body: Node3D) -> void:
	if body is HitBox:
		body.hit(_damage)
