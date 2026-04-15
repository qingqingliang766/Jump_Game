extends Node3D

# ✅ 你原来的运动参数（完全保留，一丝不动）
@export var move_speed: float = 0.6
@export var move_height: float = 2.8
@export var start_offset: float = 0.0

# ✅ 触碰音效配置
@export var hit_sound: AudioStream
@export var sound_volume: float = 0.8

var start_y: float
var audio_player: AudioStreamPlayer3D

func _ready():
	# ✅ 你原来的初始位置代码
	start_y = position.y + start_offset
	
	# ✅ 创建音效播放器
	audio_player = AudioStreamPlayer3D.new()
	audio_player.volume_db = linear_to_db(sound_volume)
	add_child(audio_player)
	
	# ✅ 自动连接Area3D信号（不用手动找节点，脚本会自动查找）
	# 因为你已经把CollisionShape3D放在了Area3D->hit_area下面，所以能直接连
	#if $hit_area:
		#$hit_area.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# ✅ 你原来的运动代码（完全不变）
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (move_height / 2) * sin(time * move_speed)
	position.y = new_y

# ✅ 触碰播放音效
func _on_body_entered(body):
	if hit_sound and audio_player:
		audio_player.stream = hit_sound
		audio_player.play()
