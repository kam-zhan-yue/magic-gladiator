class_name Sandworm
extends Node3D

const BASICALLY_ZERO = 0.001

@onready var body := %Body as SandwormBody
@onready var brain := %Brain as SandwormBrain

var _controller: SandwormController

# ========= Public Methods ============
func init_controller(controller: SandwormController) -> void:
	_controller = controller
	body.init_sandworm(self)

func init_own_segments() -> void:
	body.init_own_segments()

func init_with_segments(segments: Array[SandwormSegment]) -> void:
	body.init_with_segments(segments)

func get_head() -> Node3D:
	return body.get_head()

func split(segments: Array[SandwormSegment]) -> void:
	_controller.split(segments)

func update(delta: float) -> void:
	brain.update(delta)
	var target_pos = brain.get_body_pos()
	if target_pos == Vector3.ZERO:
		return
	body.chase(target_pos, delta)
