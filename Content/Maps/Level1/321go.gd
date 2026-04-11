extends Control

# ========== 倒计时节点（100%匹配你的场景，直接找根节点下的节点） ==========
@onready var countdown_label: Label = $countdownlabel
@onready var countdown_timer: Timer = $countdowntimer

# ========== 可调整参数 ==========
var 抬起高度: float = 12.0
var 抬起动画时长: float = 0.6
var 墙之间间隔时间: float = 0.2

var current_count: int = 3
var wall1: Node3D
var wall2: Node3D
var wall3: Node3D

func _ready():
	print("✅ 倒计时脚本启动成功！")

	# 1. 检查倒计时节点（完全匹配你的结构）
	if not is_instance_valid(countdown_label) or not is_instance_valid(countdown_timer):
		print("❌ 错误：找不到节点！请确认321go根节点下有countdownlabel和countdowntimer，名字完全一致！")
		return
	print("✅ 倒计时节点正常！")

	# 2. 自动找关卡根节点
	var level_root: Node = get_tree().current_scene
	print("✅ 当前关卡根节点：", level_root.name)

	# 3. 自动找door节点
	var door_node: Node = level_root.find_child("door", true, false)
	if not is_instance_valid(door_node):
		print("❌ 错误：关卡里找不到名字为door的节点！")
		return
	print("✅ 找到door节点！")

	# 4. 找三个墙
	wall1 = door_node.find_child("wall_0014", true, false)
	wall2 = door_node.find_child("wall_0012", true, false)
	wall3 = door_node.find_child("wall_0013", true, false)

	if not is_instance_valid(wall1) or not is_instance_valid(wall2) or not is_instance_valid(wall3):
		print("❌ 错误：door节点下找不到wall_0014 / wall_0012 / wall_0013！")
		return
	print("✅ 所有墙节点正常！")

	# 5. 初始化倒计时
	countdown_label.visible = true
	countdown_label.text = ""
	countdown_timer.wait_time = 1.0
	countdown_timer.autostart = false
	countdown_timer.one_shot = false
	countdown_timer.timeout.connect(_on_timer_timeout)
	
	# 启动倒计时
	update_count()
	countdown_timer.start()

func _on_timer_timeout():
	current_count -= 1
	update_count()

func update_count():
	if current_count > 0:
		countdown_label.text = str(current_count)
		play_countdown_anim()
	else:
		countdown_label.text = "GO!"
		countdown_label.modulate = Color(1, 1, 0)
		play_countdown_anim()
		countdown_timer.stop()
		# 1秒后隐藏GO!，开始抬墙
		var hide_timer = Timer.new()
		hide_timer.wait_time = 1.0
		hide_timer.autostart = true
		hide_timer.one_shot = true
		hide_timer.timeout.connect(func():
			countdown_label.visible = false
			hide_timer.queue_free()
			print("✅ 倒计时结束，开始抬墙！")
			lift_wall1()
		)
		add_child(hide_timer)

func lift_wall1():
	var tween = create_tween()
	var target_pos = wall1.position + Vector3(0, 抬起高度, 0)
	tween.tween_property(wall1, "position", target_pos, 抬起动画时长)
	tween.set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():
		print("✅ 第一个墙抬起完成！")
		var wait_timer = Timer.new()
		wait_timer.wait_time = 墙之间间隔时间
		wait_timer.autostart = true
		wait_timer.one_shot = true
		wait_timer.timeout.connect(func():
			lift_wall2()
			wait_timer.queue_free()
		)
		add_child(wait_timer)
	)

func lift_wall2():
	var tween = create_tween()
	var target_pos = wall2.position + Vector3(0, 抬起高度, 0)
	tween.tween_property(wall2, "position", target_pos, 抬起动画时长)
	tween.set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():
		print("✅ 第二个墙抬起完成！")
		var wait_timer = Timer.new()
		wait_timer.wait_time = 墙之间间隔时间
		wait_timer.autostart = true
		wait_timer.one_shot = true
		wait_timer.timeout.connect(func():
			lift_wall3()
			wait_timer.queue_free()
		)
		add_child(wait_timer)
	)

func lift_wall3():
	var tween = create_tween()
	var target_pos = wall3.position + Vector3(0, 抬起高度, 0)
	tween.tween_property(wall3, "position", target_pos, 抬起动画时长)
	tween.set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():
		print("✅ 第三个墙抬起完成！所有墙已全部抬起！")
	)

func play_countdown_anim():
	var tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2(1.6, 1.6), 0.15)
	tween.tween_property(countdown_label, "scale", Vector2(1, 1), 0.15)
	tween.finished.connect(func():
		if countdown_label.text != "GO!":
			countdown_label.modulate = Color(1, 1, 1)
	)
