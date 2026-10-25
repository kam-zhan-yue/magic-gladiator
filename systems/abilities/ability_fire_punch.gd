class_name AbilityFirePunch
extends Ability

enum FirePunchIndex { None, First, Second, Third }
enum State { None, Punching, Waiting }

@export var combo_interval := 1.0
@export var first_punch_damage := 10.0
@export var first_punch_duration := 0.2
@export var second_punch_damage := 20.0
@export var second_punch_duration := 0.5
@export var third_punch_damage := 50.0
@export var third_punch_duration := 0.8

@export var first_punch_effect: PackedScene
@export var second_punch_effect: PackedScene
@export var third_punch_effect: PackedScene

var _current_index := FirePunchIndex.None
var _current_state := State.None

var _punch_timer := 0.0
var _combo_timer := 0.0

func ability_update(delta: float) -> void:
	if _current_index == FirePunchIndex.None:
		return

	if _current_state == State.Punching:
		_punch_timer -= delta
		if _punch_timer <= 0:
			if _current_index == FirePunchIndex.Third:
				_reset_state()
			else:
				_combo_timer = combo_interval
				_current_state = State.Waiting
	elif _current_state == State.Waiting:
		_combo_timer -= delta
		if _combo_timer <= 0:
			_reset_state()


func _reset_state() -> void:
	_current_state = State.None
	_current_index = FirePunchIndex.None


func ability_can_cast() -> bool:
	return _current_state != State.Punching

func ability_cast() -> void:
	if _current_index == FirePunchIndex.None:
		_first_punch()
	elif _current_index == FirePunchIndex.First:
		_second_punch()
	elif _current_index == FirePunchIndex.Second:
		_third_punch()

func _first_punch() -> void:
	print("First Punch")
	_current_state = State.Punching
	_current_index = FirePunchIndex.First
	_punch_timer = first_punch_duration
	spawn_effect(first_punch_effect, first_punch_damage)

func _second_punch() -> void:
	print("Second Punch")
	_current_state = State.Punching
	_current_index = FirePunchIndex.Second
	_punch_timer = second_punch_duration
	spawn_effect(second_punch_effect, second_punch_damage)

func _third_punch() -> void:
	print("Third Punch")
	_current_state = State.Punching
	_current_index = FirePunchIndex.Third
	_punch_timer = third_punch_duration
	spawn_effect(third_punch_effect, third_punch_damage)

func spawn_effect(effect: PackedScene, damage: float) -> void:
	var instance = effect.instantiate() as AbilityFirePunchEffect
	_player.shot_origin.add_child(instance)
	instance.play(damage)
