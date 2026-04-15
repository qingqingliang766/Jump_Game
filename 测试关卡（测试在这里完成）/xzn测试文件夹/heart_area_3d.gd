extends Area3D

# 可调节参数
@export var rotate_speed: float = 90.0
@export var boost_amount: float = 14.0
@export var boost_time: float = 5.0
@export var respawn_delay: float = 10.0 # 复活时间

var sound_player: AudioStreamPlayer3D
var is_collected: bool = false # 标记是否已被拾取

func _ready():
	sound_player = $heartAudioStreamPlayer3D
	body_entered.connect(_on_body_entered)

func _process(delta):
	# 如果没被拾取，才进行旋转动画
	if not is_collected:
		get_parent().rotate_y(deg_to_rad(rotate_speed * delta))

func _on_body_entered(_body: Node3D):
	# 检查名字为 Player 且当前没有处于“冷却”状态
	if not is_collected and _body.name == "Player":
		collect_heart(_body)

func collect_heart(player):
	is_collected = true
	
	# 1. 播放音效
	if sound_player != null:
		sound_player.play()
	
	# 2. 调用玩家加速
	if player.has_method("start_boost"):
		player.start_boost(boost_amount, boost_time)
	
	# 3. 让他“消失”但不销毁
	# 隐藏父节点（爱心的模型）
	get_parent().hide()
	# 禁用碰撞检测（防止重复触发），必须用 set_deferred 否则报错
	set_deferred("monitoring", false)
	
	# 4. 开启协程计时复活
	await get_tree().create_timer(respawn_delay).timeout
	
	# 5. “复活”爱心
	respawn_heart()

func respawn_heart():
	is_collected = false
	get_parent().show() # 重新显示模型
	set_deferred("monitoring", true) # 重新开启碰撞
