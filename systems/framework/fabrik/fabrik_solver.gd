class_name FabrikSolver

func solve(target_pos: Vector3, anchor_pos: Vector3, segments: Array[FabrikSegment]) -> void:
	_process_forwards_recursive(segments, target_pos, len(segments) - 1)
	_process_backwards_recursive(segments, anchor_pos, 0)

func _process_forwards_recursive(segments: Array[FabrikSegment], target_pos: Vector3, index: int) -> void:
	if index < 0:
		return
	var prev_pos := segments[index].position
	segments[index].position = target_pos

	var difference := target_pos - prev_pos
	var next_pos := target_pos - difference.normalized() * segments[index].length
	if index == len(segments) - 1:
		_process_forwards_recursive(segments, next_pos, index - 1)
	else:
		var angle_to_pos := prev_pos.angle_to(next_pos)
		if angle_to_pos > segments[index].angle:
			var direction := difference.normalized().rotated(Vector3.UP, segments[index].angle)
			next_pos = target_pos + direction * segments[index].length
		_process_forwards_recursive(segments, next_pos, index - 1)


func _process_backwards_recursive(segments: Array[FabrikSegment], anchor_pos: Vector3, index: int) -> void:
	if index >= len(segments):
		return
	var prev_pos := segments[index].position
	segments[index].position = anchor_pos

	var difference := anchor_pos - prev_pos
	var next_pos := anchor_pos - difference.normalized() * segments[index].length
	_process_backwards_recursive(segments, next_pos, index + 1)

	if index == 0:
		_process_backwards_recursive(segments, next_pos, index + 1)
	else:
		var angle_to_pos := prev_pos.angle_to(next_pos)
		if angle_to_pos > segments[index].angle:
			var direction := difference.normalized().rotated(Vector3.UP, segments[index].angle)
			next_pos = anchor_pos + direction * segments[index].length
		_process_backwards_recursive(segments, next_pos, index + 1)
	# if difference.length() >+ segments[index].length:
	# 	var next_pos := anchor_pos - difference.normalized() * segments[index].length
	# 	_process_backwards_recursive(segments, next_pos, index + 1)
	# else:
	# 	var next_pos := anchor_pos - difference
	# 	_process_backwards_recursive(segments, next_pos, index + 1)


# func _process_forwards(target_pos: Vector3, segments: Array[FabrikSegment]) -> void:
# 	segments[-1].position = target_pos
# 	for i in range(len(segments) - 2, -1, -1):
# 		var curr_node := segments[i+1]
# 		var next_node := segments[i]
# 		_calculate_constraint(curr_node, next_node)
#
#
# func _process_backwards(anchor_pos: Vector3, segments: Array[FabrikSegment]) -> void:
# 	segments[0].position = anchor_pos
# 	for i in range(1, len(segments)):
# 		var curr_node := segments[i-1]
# 		var next_node := segments[i]
# 		_calculate_constraint(curr_node, next_node)
#
#
# func _calculate_constraint(curr: FabrikSegment, next: FabrikSegment) -> void:
# 	var next_position := next.position
# 	var curr_position := curr.position
# 	var difference := next_position - curr_position
#
# 	var constraint := next.length
#
# 	var new_position := curr_position + difference.normalized() * constraint
# 	next.position = new_position
# 	# if difference.length() >= constraint:
# 	# 	var new_position := curr_position + difference.normalized() * constraint
# 	# 	next.position = new_position
# 	# else:
# 	# 	next.position = curr_position + difference
