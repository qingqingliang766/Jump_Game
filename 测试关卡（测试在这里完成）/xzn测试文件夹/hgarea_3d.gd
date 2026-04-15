extends Area3D

@onready var success_label = $UILayer/SuccessLabel

# 编辑器已经绑定了这个函数，代码里绝对不要再 connect！
func _on_body_entered(_body):
	if _body.name == "Player":
		pick_crown()

func pick_crown():
	# 1. 立即隐藏皇冠，防止重复触发
	visible = false

	# 2. 显示成功提示
	if success_label:
		success_label.visible = true

	# 3. 播放胜利音效
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

	# 4. 延迟修改物理属性，彻底解决 locked 报错
	call_deferred("_disable_collision")

# 封装物理属性修改，延迟执行
func _disable_collision():
	monitoring = false
	collision_layer = 0
	# 3秒后隐藏提示
	await get_tree().create_timer(3.0).timeout
	if success_label:
		success_label.visible = false
