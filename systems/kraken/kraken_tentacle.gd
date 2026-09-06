@tool
class_name KrakenTentacle
extends Node3D

@onready var brain := %KrakenTentacleBrain as KrakenTentacleBrain
@onready var body := %KrakenTentacleBody as KrakenTentacleBody

func init() -> void:
	brain.init()
	body.init()

func update(delta: float) -> void:
	brain.update(delta)
	body.update(brain.get_target_pos(), delta)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update(delta)
