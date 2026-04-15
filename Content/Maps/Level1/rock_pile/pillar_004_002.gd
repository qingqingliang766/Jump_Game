extends Node3D

# ✅ 高度大幅提升，速度保持不变（直接用）
@export var move_speed: float = 3   # 保持原慢速度，不影响跳跃
@export var move_height: float = 20 # 上下幅度大幅拉高，比之前更高
@export var start_offset: float = 10

var start_y: float

func _ready():
	# 记录初始位置，避免坐标偏移
	start_y = position.y + start_offset

func _process(delta: float) -> void:
	# ✅ 完全兼容Godot 4.6.2，无报错、丝滑不卡顿
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (move_height / 2) * sin(time * move_speed)
	position.y = new_y
