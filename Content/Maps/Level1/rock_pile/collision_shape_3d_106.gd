extends CollisionShape3D

# 旋转速度（数值越大转得越快，单位：度/秒）
@export var speed: float = 100

func _process(delta: float) -> void:
	# 绕 Y 轴 360° 持续旋转
	rotation.y += deg_to_rad(speed) * delta
