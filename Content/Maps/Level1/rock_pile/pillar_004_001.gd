extends Node3D

# 你原来的代码 一丝不动
@export var move_speed: float = 0.6
@export var move_height: float = 2.8
@export var start_offset: float = 0.0

# 仅加这一行：触碰音效
@export var hit_sound: AudioStream

var start_y: float
var audio: AudioStreamPlayer3D

func _ready():
	start_y = position.y + start_offset
	# 自动创建音效播放器（不用手动加节点）
	audio = AudioStreamPlayer3D.new()
	add_child(audio)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# 你原来的运动代码 完全不变
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (move_height / 2) * sin(time * move_speed)
	position.y = new_y

# 触碰播放声音（手动调用，不依赖节点类型）
func play_hit_sound():
	if hit_sound:
		audio.stream = hit_sound
		audio.play()
