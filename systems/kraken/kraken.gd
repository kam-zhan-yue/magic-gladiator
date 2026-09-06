class_name Kraken
extends Node3D

@export var tentacle_scene: PackedScene
@export var num_tentacles := 1

var _tentacles: Array[KrakenTentacle] = []

func init() -> void:
	for i in range(num_tentacles):
		var tentacle := _instantiate_tentacle()
		tentacle.init()


func _instantiate_tentacle() -> KrakenTentacle:
	var tentacle := tentacle_scene.instantiate() as KrakenTentacle
	_tentacles.append(tentacle)
	add_child(tentacle)
	tentacle.global_position = global_position
	return tentacle


func update(delta: float) -> void:
	for tentacle in _tentacles:
		tentacle.update(delta)
