extends Node3D

# ✅ 完全匹配旁边石头的参数（幅度一致+速度同步）
@export var move_speed: float = 0.9   # 和旁边石头速度完全一致
@export var move_height: float = 3.5 # 上下幅度和旁边石头高度对齐
@export var start_offset: float = 0.0

var start_y: float

func _ready():
	# 记录初始位置，避免坐标偏移
	start_y = position.y + start_offset

func _process(delta: float) -> void:
	# ✅ 完全兼容Godot 4.6.2，无报错、丝滑同步
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (move_height / 2) * sin(time * move_speed)
	position.y = new_y
