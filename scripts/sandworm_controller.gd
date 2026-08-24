class_name SandwormController
extends Node3D

@onready var sandworm := %Sandworm as Sandworm
@onready var target := %SandwormTarget as Node3D
@onready var radius := 15.0
@onready var frequency := 2.0

@onready var y_radius := 2.0
@onready var y_frequency := 5.0

var _time = 0.0

func _ready() -> void:
	sandworm.init()
	target.global_position = sandworm.get_head().global_position

func _process(delta: float) -> void:
	_time += delta
	var target_pos = target.global_position
	target_pos.x = cos(_time * frequency) * radius
	target_pos.y = sin(_time * y_frequency) * y_radius
	target_pos.z = sin(_time * frequency) * radius
	target.global_position = target_pos
	sandworm.chase(target_pos, delta)
