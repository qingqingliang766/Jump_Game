extends StaticBody3D

@export var max_angle: float = 90.0
@export var swing_speed: float = 3.0

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
	var t = sin(time_elapsed * swing_speed)
	
	# 上下摆动
	rotation.z = deg_to_rad(t * max_angle)
