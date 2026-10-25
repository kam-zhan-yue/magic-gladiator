class_name DebugPlayer
extends Node3D

@export var speed := 10.0


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var direction = Vector3(0, -input_vector.y, input_vector.x)
	global_position += direction * speed * delta
