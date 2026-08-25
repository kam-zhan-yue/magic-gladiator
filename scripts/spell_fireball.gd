class_name SpellFireball
extends Spell

@export var cooldown_time := 0.2
@export var damage := 10.0

@onready var shot_origin := %ShotOrigin as Node3D
@onready var launch_speed := 50.0
@export var fireball_scene: PackedScene

var _timer = 0

func update(delta: float) -> void:
	if _timer > 0:
		_timer -= delta

func can_cast() -> bool:
	return _timer <= 0

func cast() -> void:
	var fireball = fireball_scene.instantiate() as Projectile
	Projectiles.add(fireball)
	fireball.global_position = shot_origin.global_position
	fireball.shoot(damage, launch_speed * -shot_origin.global_transform.basis.z)
	_timer = cooldown_time
