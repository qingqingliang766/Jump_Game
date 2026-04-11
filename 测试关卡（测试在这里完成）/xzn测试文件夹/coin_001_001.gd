extends MeshInstance3D

# 🔴 拾取音效（可选，在检查器里拖入音频文件）
@export var pick_sound: AudioStream

# 🔴 自动获取金币的Area3D节点
@onready var coin_area: Area3D = $CoinArea

func _ready():
	# 🔴 连接Area3D的「物体进入」信号，触发拾取
	coin_area.body_entered.connect(_on_body_entered)

# 🔴 当有物体进入金币区域时，自动执行这个函数
func _on_body_entered(body: Node3D):
	# 🔴 只响应「Player」节点（玩家），避免其他物体触发
	if body.name == "Player":
		# 1. 调用全局单例，金币数+1
		Global.add_coin()
		
		# 2. 播放拾取音效（如果设置了音效文件）
		if pick_sound:
			# 创建一个3D音效播放器，在金币位置播放
			var audio_player = AudioStreamPlayer3D.new()
			audio_player.stream = pick_sound
			get_parent().add_child(audio_player)
			audio_player.global_position = global_position
			audio_player.play()
		
		# 3. 销毁金币（拾取后消失）
		queue_free()

# 🔴 【可选】给金币加自动旋转动画，更美观
func _process(delta: float):
	# 绕Y轴旋转，速度可以自己调（数字越大转越快）
	rotation.y += delta * 2.0
