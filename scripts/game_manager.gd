class_name GameManager
extends Node3D

@onready var projectile_holder := %Projectiles as Node3D

func _ready() -> void:
	Projectiles.init(projectile_holder)

func _process(delta: float) -> void:
	Projectiles.update(delta)
