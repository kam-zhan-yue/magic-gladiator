class_name BattleTestLevel
extends Node3D

@onready var player := %Player as Player

func _ready() -> void:
	player.init()

	_inject()

func _inject() -> void:
	Services.player = player


func _process(delta: float) -> void:
	Projectiles.update(delta)
