extends Node3D

# 绑定节点（路径100%匹配你场景里的节点名！）
@onready var countdown_label: Label = $CanvasLayer/countdownlabel
@onready var countdown_timer: Timer = $countdowntimer  # 完全和你场景里的Timer名一致！

# 倒计时当前数字
var current_count: int = 3

# 游戏启动自动执行
func _ready():
	# 初始化Label：可见、清空文字、重置为白色
	countdown_label.visible = true
	countdown_label.text = ""
	countdown_label.modulate = Color(1, 1, 1)
	
	# 连接定时器信号：每次1秒到了就执行倒计时逻辑
	countdown_timer.timeout.connect(_on_timer_timeout)
	
	# 启动倒计时：先显示第一个数字3
	show_current_count()
	countdown_timer.start()

# 定时器每1秒触发一次的核心逻辑
func _on_timer_timeout():
	# 数字减1
	current_count -= 1
	# 显示新数字
	show_current_count()

# 显示当前倒计时数字
func show_current_count():
	if current_count > 0:
		# 显示3/2/1数字
		countdown_label.text = str(current_count)
		play_pop_anim() # 播放数字放大弹动动画
	else:
		# 数字到0，显示GO!（黄色醒目）
		countdown_label.text = "GO!"
		countdown_label.modulate = Color(1, 1, 0)
		play_pop_anim()
		# 停止定时器
		countdown_timer.stop()
		# 1秒后自动隐藏GO!
		var hide_timer = Timer.new()
		hide_timer.wait_time = 1.0
		hide_timer.autostart = true
		hide_timer.one_shot = true
		hide_timer.timeout.connect(func():
			countdown_label.visible = false
			hide_timer.queue_free()
		)
		add_child(hide_timer)

# 数字放大弹动动画（蛋仔同款效果）
func play_pop_anim():
	var tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2(1.6, 1.6), 0.15)
	tween.tween_property(countdown_label, "scale", Vector2(1, 1), 0.15)
	tween.finished.connect(func():
		if countdown_label.text != "GO!":
			countdown_label.modulate = Color(1, 1, 1)
	)
