extends Area3D

# 定义成功标签的引用（你可以在编辑器中拖拽赋值）
@onready var success_label = $UILayer/SuccessLabel

# 当游戏开始时执行
func _ready():
	# 连接身体进入信号（检测玩家接触）
	body_entered.connect(_on_body_entered)
	# 也可以用 area_entered（如果玩家是 Area3D）
	# area_entered.connect(_on_area_entered)

# 检测到有身体（如CharacterBody3D）进入皇冠区域时触发
func _on_body_entered(body):
	# 这里可以判断是不是玩家（比如给玩家节点命名为Player）
	if body.name == "Player":
		pick_crown()

# 检测到有区域（Area3D）进入皇冠区域时触发（备选）
func _on_area_entered(area):
	if area.name == "Player":
		pick_crown()

# 核心拾取逻辑
func pick_crown():
	# 1. 让皇冠消失
	self.visible = false  # 隐藏整个皇冠节点
	# 如果只想隐藏模型，可以用：$MeshInstance3D.visible = false
	
	# 2. 禁用碰撞（防止重复拾取）
	monitoring = false
	collision_layer = 0
	
	# 3. 显示成功标签
	if success_label:
		success_label.visible = true
		# 可选：3秒后自动隐藏标签
		await get_tree().create_timer(3.0).timeout
		success_label.visible = false
	
	# 可选：播放拾取音效/粒子效果
	# $AudioStreamPlayer.play()
