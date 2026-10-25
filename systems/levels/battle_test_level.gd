class_name BattleTestLevel
extends Node3D

@onready var player := %Player as Player
@onready var ability_controller := %AbilityController as AbilityController

func _ready() -> void:
	_inject()
	player.init()
	ability_controller.init();


func _inject() -> void:
	Services.player = player
	Services.ability_controller = ability_controller


func _process(delta: float) -> void:
	Projectiles.update(delta)
