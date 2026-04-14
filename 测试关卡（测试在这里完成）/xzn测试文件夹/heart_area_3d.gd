extends Area3D

# 可调节参数（在属性面板直接改）
@export var rotate_speed: float = 90.0  # 旋转速度，每秒90度
@export var boost_amount: float = 14.0  # 加速后的速度
@export var boost_time: float = 5.0     # 加速持续5秒

# 音效播放器（完全适配你节点名，不存在也不报错）
var sound_player: AudioStreamPlayer3D

func _ready():
	# 👇 这里用你实际的节点名，100%匹配
	sound_player = $heartAudioStreamPlayer3D
	# 连接拾取信号
	body_entered.connect(_on_body_entered)

# 每帧让爱心绕Y轴旋转
func _process(delta):
	get_parent().rotate_y(deg_to_rad(rotate_speed * delta))

# 拾取触发函数，参数加下划线消除警告
func _on_body_entered(_body: Node3D):
	# 只响应玩家
	if _body.name == "Player":
		# 安全播放音效：只有节点存在时才播放
		if sound_player != null:
			sound_player.play()
		
		# 给玩家加加速Buff
		_apply_boost(_body)
		
		# 拾取后删除整个爱心
		get_parent().queue_free()

# 加速逻辑封装
func _apply_boost(player: CharacterBody3D):
	# 保存玩家原始速度
	var original_walk = player.walk_speed
	var original_sprint = player.sprint_speed
	
	# 临时提升速度
	player.walk_speed = boost_amount
	player.sprint_speed = boost_amount
	player.current_speed = boost_amount
	
	# 等待加速时间结束
	await get_tree().create_timer(boost_time).timeout
	
	# 恢复原始速度
	player.walk_speed = original_walk
	player.sprint_speed = original_sprint
	player.current_speed = original_walk
