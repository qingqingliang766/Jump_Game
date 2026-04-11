extends StaticBody3D

@export var 旋转周期: float = 8.0
@export var 最大旋转角度: float = 360.0

var timer: float = 0.0

func _process(delta: float) -> void:
	timer += delta
	rotation.y = deg_to_rad(sin(timer * 2 * PI / 旋转周期) * 最大旋转角度)
