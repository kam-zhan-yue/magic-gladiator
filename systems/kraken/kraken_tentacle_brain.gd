@tool
class_name KrakenTentacleBrain
extends Node3D

@export var animated_position: Node3D
@export var debug_position: Node3D
@onready var animation_player := %AnimationPlayer as AnimationPlayer

func init() -> void:
	animation_player.play("kraken_move")

func update(_delta: float) -> void:
	debug_position.global_position = get_target_pos()


func get_target_pos() -> Vector3:
	# return Services.player.global_position
	return animated_position.global_position
