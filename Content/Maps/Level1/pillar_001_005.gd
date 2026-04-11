extends Node3D

# ==========================================
# 可调节参数（在检查器面板直接改）
# ==========================================
@export var move_speed: float = 1.5    # 上下移动速度（米/秒，调慢更丝滑）
@export var move_height: float = 0.8  # 上下滑动总高度（0.8米，幅度超小）
@export var start_offset: float = 0.0 # 初始偏移（0=从最低点开始）

# 运行时变量
var start_y: float  # 初始Y坐标
var direction: float = 1.0 # 移动方向（1=向上，-1=向下）

func _ready():
	# 记录初始Y坐标，作为运动基准
	start_y = position.y
	# 应用初始偏移
	position.y = start_y + start_offset * move_height
	# 自动修正方向
	if start_offset >= 1.0:
		direction = -1.0

func _process(delta: float):
	# 计算目标位置
	var target_y = start_y + move_height * direction
	
	# 平滑移动到目标位置
	position.y = move_toward(position.y, target_y, move_speed * delta)
	
	# 到达目标位置后，反转方向，实现往复
	if position.y == target_y:
		direction *= -1
