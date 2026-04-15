extends AnimatableBody3D  # 必须改为这个，否则无法处理物理旋转

@export_category("障碍物设置")
@export var rotation_speed: float = 2.0  # 旋转速度
@export var reverse_direction: bool = false # 是否反向旋转

func _physics_process(delta: float) -> void:
	# 计算旋转方向
	var dir = -1.0 if reverse_direction else 1.0
	
	# 使用 rotate_y 绕垂直轴旋转
	# 这样旋转时，模型和碰撞体会同步移动
	rotate_y(rotation_speed * delta * dir)
