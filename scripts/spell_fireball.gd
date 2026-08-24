class_name SpellFireball
extends Spell

@onready var shot_origin := %ShotOrigin as Node3D
@export var fireball_scene: PackedScene
@export var cooldown_time = 0.2

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
	_timer = cooldown_time
