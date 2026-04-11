extends Node3D

@export var swing_angle: float = 45.0
@export var swing_speed: float = 2.0
@export var pendulum_length: float = 2.0

var timer: float = 0.0

func _process(delta: float) -> void:
	timer += delta * swing_speed
	var angle = deg_to_rad(sin(timer) * swing_angle)
	var offset_x = sin(angle) * pendulum_length
	var offset_y = -cos(angle) * pendulum_length + pendulum_length
	position = Vector3(offset_x, offset_y, 0)
	look_at(get_parent().global_position, Vector3.UP)
