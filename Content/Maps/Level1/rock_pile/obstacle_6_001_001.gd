extends MeshInstance3D

# 旋转速度（每秒多少度）
@export var rotate_speed: float = 100

func _process(delta: float) -> void:
	# 绕 Y 轴 360° 持续旋转
	rotation.y += deg_to_rad(rotate_speed) * delta
