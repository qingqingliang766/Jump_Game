extends Node3D

# 旋转速度（度/秒，数值越大转越快）
@export var rotate_speed: float = 360.0  # 直接拉满，一眼就能看到转

func _process(delta: float):
	# 绕Y轴匀速旋转
	rotate_y(deg_to_rad(rotate_speed * delta))
