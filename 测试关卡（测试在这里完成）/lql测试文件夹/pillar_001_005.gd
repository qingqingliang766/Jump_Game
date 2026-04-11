extends Node3D

# 丝滑慢动参数（已调好，直接用）
@export var move_speed: float = 1.0   # 控制快慢，0.5-1.5 区间最丝滑
@export var move_height: float = 0.8  # 上下浮动高度
@export var start_offset: float = 0.0

var start_y: float

func _ready():
	# 记录初始位置，避免坐标偏移
	start_y = position.y + start_offset

func _process(delta: float) -> void:
	# ✅ Godot 4.6 正确时间API：Time.get_ticks_msec()
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (move_height / 2) * sin(time * move_speed)
	position.y = new_y
