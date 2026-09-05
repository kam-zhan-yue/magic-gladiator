extends Node

const BASICALLY_ZERO = 0.001
const GRAVITY := -10.0

func get_movement_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back")

func wait_seconds(time: float):
	await get_tree().create_timer(time).timeout
