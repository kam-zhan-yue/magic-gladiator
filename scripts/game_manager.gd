class_name GameManager
extends Node3D

@onready var player := %Player as Player
@onready var sandworm := %SandwormController as SandwormController
@onready var projectile_holder := %Projectiles as Node3D

func _ready() -> void:
	player.init()
	sandworm.init()
	Projectiles.init(projectile_holder)

	_inject()

func _inject() -> void:
	Services.player = player


func _process(delta: float) -> void:
	Projectiles.update(delta)
