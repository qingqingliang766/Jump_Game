extends Node3D

@export var 旋转周期: float = 9.0
@export var 最大旋转角度: float = 360.0

var timer: float = 0.0

func _process(delta: float) -> void:
	timer += delta
	# 绕Y轴（垂直轴）做360°往复旋转，完美适配闯关陷阱
	rotation.y = deg_to_rad(sin(timer * 2 * PI / 旋转周期) * 最大旋转角度)
