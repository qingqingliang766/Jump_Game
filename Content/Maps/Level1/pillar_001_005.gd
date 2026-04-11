extends Node3D

# 移动速度（数值越小，滑动越慢）
@export var move_speed: float = 1.5
# 移动高度（上下浮动的总高度）
@export var move_height: float = 0.8
# 起点Y轴偏移（初始位置微调）
@export var start_offset: float = 0.0

# 初始Y轴位置
var start_y: float

func _ready():
	# 记录初始位置，加上偏移量
	start_y = global_position.y + start_offset

func _process(delta: float) -> void:
	# 用正弦函数实现平滑上下往复运动
	# 公式：y = 初始y + 高度/2 * sin(时间 * 速度)
	var new_y = start_y + (move_height / 2) * sin(Time.get_ticks_msec() / 1000 * move_speed)
	global_position.y = new_y
