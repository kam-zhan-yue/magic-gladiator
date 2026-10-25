class_name SpellFireball
extends Spell

@export var damage := 10.0

@onready var shot_origin := %ShotOrigin as Node3D
@onready var launch_speed := 50.0
@export var fireball_scene: PackedScene

func spell_update(_delta: float) -> void:
	pass

func spell_can_cast() -> bool:
	return true

func spell_cast() -> void:
	var fireball = fireball_scene.instantiate() as Projectile
	Projectiles.add(fireball)
	fireball.global_position = shot_origin.global_position
	fireball.shoot(damage, launch_speed * -shot_origin.global_transform.basis.z)
	_timer = cooldown_time
