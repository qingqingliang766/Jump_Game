extends Node3D

# 旋转速度（度/秒，数值越大转越快，默认180是2秒转一圈）
@export var rotate_speed: float = 180.0

func _process(delta: float):
	# 绕Y轴匀速旋转，完美适配风扇
	rotate_y(deg_to_rad(rotate_speed * delta))
