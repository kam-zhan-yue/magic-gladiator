class_name KrakenLevel
extends Node3D

@onready var player := %Player as Player
@onready var kraken := %Kraken as Kraken
@onready var projectile_holder := %Projectiles as Node3D

func _ready() -> void:
	player.init()
	kraken.init()
	Projectiles.init(projectile_holder)

	_inject()

func _inject() -> void:
	Services.player = player
	Services.kraken = kraken


func _process(delta: float) -> void:
	kraken.update(delta)
	Projectiles.update(delta)
