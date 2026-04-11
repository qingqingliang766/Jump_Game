extends Area3D

@onready var success_label = $UILayer/SuccessLabel

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		pick_crown()

func pick_crown():
	# 1. 隐藏皇冠，禁用碰撞（防止重复拾取）
	visible = false
	monitoring = false
	collision_layer = 0

	# 2. 播放成功音效（绝对稳定写法）
	# 👇 仅需修改这里的路径！右键音频文件→复制路径，直接粘贴
	var audio_path = "res://测试关卡（测试在这里完成）/xzn测试文件夹/胜利音效：管弦乐下降-正确答案-游戏_爱给网_aigei_com.mp3"
	var sound = load(audio_path)
	if sound:
		var audio = AudioStreamPlayer.new()
		add_child(audio)
		audio.stream = sound
		audio.play()
		print("✅ 音效播放成功！")
	else:
		print("❌ 加载音频失败，请检查路径：", audio_path)

	# 3. 显示成功标签
	if success_label:
		success_label.visible = true
		await get_tree().create_timer(3.0).timeout
		success_label.visible = false
