class_name AbilityFirePunch
extends Ability

enum FirePunchIndex { None, First, Second, Third }

@export var combo_interval := 1.0
@export var first_punch_damage := 10.0
@export var first_punch_duration := 0.2
@export var second_punch_damage := 20.0
@export var second_punch_duration := 0.5
@export var third_punch_damage := 50.0
@export var third_punch_duration := 0.8

var _current_index := FirePunchIndex.None

var _punch_timer := 0.0
var _combo_timer := 0.0

func ability_update(delta: float) -> void:
	if _current_index == FirePunchIndex.None:
		return

	if _punch_timer > 0:
		_punch_timer -= delta

	if _combo_timer > 0:
		_combo_timer -= delta

	if _punch_timer < 0:
		_punch_timer = 0
		_combo_timer = combo_interval


func _is_punching() -> bool:
	return _punch_timer > 0

func _can_combo() -> bool:
	return _combo_timer > 0

func ability_can_cast() -> bool:
	return !_is_punching() or _can_combo()

func ability_cast() -> void:
	if _current_index == FirePunchIndex.None:
		_first_punch()
	elif _current_index == FirePunchIndex.First:
		_second_punch()
	elif _current_index == FirePunchIndex.Second:
		_third_punch()

func _first_punch() -> void:
	print("First Punch")
	_current_index = FirePunchIndex.First
	_punch_timer = first_punch_duration

func _second_punch() -> void:
	print("Second Punch")
	_current_index = FirePunchIndex.Second
	_punch_timer = second_punch_duration

func _third_punch() -> void:
	print("Third Punch")
	_current_index = FirePunchIndex.Third
	_punch_timer = third_punch_duration
