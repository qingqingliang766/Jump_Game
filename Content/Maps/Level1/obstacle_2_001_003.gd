extends MeshInstance3D

# 旋转速度（可在编辑器调整）
@export var speed: float = 100.0

func _process(delta: float) -> void:
	# 绕 Y 轴 360° 无限旋转
	rotation.y += deg_to_rad(speed) * delta
