extends MeshInstance3D
# 旋转速度（可在编辑器里调整，单位：度/秒）
@export var rotate_speed: float = 100.0

func _process(delta: float) -> void:
	# 绕 Y 轴平滑旋转，delta 保证不同设备速度一致
	rotate_y(rotate_speed * delta)
