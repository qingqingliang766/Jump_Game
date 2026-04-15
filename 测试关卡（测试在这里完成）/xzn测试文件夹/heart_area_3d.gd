extends Area3D

# 可调节参数（在属性面板直接改）
@export var rotate_speed: float = 90.0
@export var boost_amount: float = 14.0
@export var boost_time: float = 5.0

var sound_player: AudioStreamPlayer3D

func _ready():
	sound_player = $heartAudioStreamPlayer3D
	body_entered.connect(_on_body_entered)

func _process(delta):
	get_parent().rotate_y(deg_to_rad(rotate_speed * delta))

func _on_body_entered(_body: Node3D):
	if _body.name == "Player":
		# 播放音效
		if sound_player != null:
			sound_player.play()
		
		# 调用玩家加速
		_body.start_boost(boost_amount, boost_time)
		
		# 销毁爱心
		get_parent().queue_free()
