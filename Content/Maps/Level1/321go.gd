extends Node

# 绑定节点（100%匹配你当前场景的相对路径，绝对不会错！）
@onready var countdown_label: Label = $CanvasLayer/countdownlabel
@onready var countdown_timer: Timer = $countdowntimer

# 倒计时当前数字
var current_count: int = 3

# 游戏启动自动执行
func _ready():
	# 保险：先检查节点是否找到，避免null崩溃
	if not countdown_label or not countdown_timer:
		push_error("倒计时节点未找到！请检查节点名和路径！")
		return
	
	# 初始化Label：可见、清空文字、重置为白色
	countdown_label.visible = true
	countdown_label.text = ""
	countdown_label.modulate = Color(1, 1, 1)
	
	# 连接定时器信号：每1秒触发一次倒计时
	countdown_timer.timeout.connect(_on_timer_timeout)
	
	# 启动倒计时：先显示第一个数字3
	show_current_count()
	countdown_timer.start()

# 定时器每1秒触发的核心逻辑
func _on_timer_timeout():
	current_count -= 1
	show_current_count()

# 显示当前倒计时数字
func show_current_count():
	if current_count > 0:
		# 显示3/2/1
		countdown_label.text = str(current_count)
		play_pop_anim()
	else:
		# 显示GO!（黄色醒目）
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
