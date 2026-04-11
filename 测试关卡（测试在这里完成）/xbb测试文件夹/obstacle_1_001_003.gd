extends Node3D

@export var radius: float = 2.0
@export var speed: float = 90.0

var angle: float = 0.0

func _process(delta: float) -> void:
	angle += deg_to_rad(speed * delta)
	var offset = Vector3(0, sin(angle) * radius, cos(angle) * radius)
	position = offset
	look_at(get_parent().global_position, Vector3.RIGHT)
