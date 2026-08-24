extends Node

func get_movement_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back")
