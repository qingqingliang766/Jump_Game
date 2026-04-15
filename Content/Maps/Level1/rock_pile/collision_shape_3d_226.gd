extends CollisionShape3D

# 旋转速度（数值越大转得越快）
@export var speed: float = 500.0

func _process(delta: float) -> void:
	# 绕 Y 轴 360° 一直旋转
	rotation.y += deg_to_rad(speed) * delta
