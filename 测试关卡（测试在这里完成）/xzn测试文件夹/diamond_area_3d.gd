extends Area3D

# 自动获取音效播放器
@onready var sound_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
# 旋转速度（可自己改，数值越大转得越快）
@export var rotate_speed: float = 90.0

func _ready():
	body_entered.connect(_on_body_entered)

# 每帧执行，让钻石绕Y轴旋转
func _process(delta):
	# 绕Y轴旋转，delta保证不同设备速度一致
	get_parent().rotate_y(deg_to_rad(rotate_speed * delta))

func _on_body_entered(body):
	if body.name == "Player":
		# 播放音效
		sound_player.play()
		# 加钻石计数
		Global.add_diamond()
		# 等音效播完再删除（0.5秒可根据你的音效长度调整）
		await get_tree().create_timer(0.5).timeout
		# 删除整个钻石
		get_parent().queue_free()
