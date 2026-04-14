extends CharacterBody3D

# ==========================================
# 导出参数 (在属性面板调节)
# ==========================================
@export_category("Movement")
@export var walk_speed: float = 8.0
# 注意：你设定的冲刺速度(4.5)比走路(8.0)还慢。如果想加速，记得在面板里把它调大，比如 12.0
@export var sprint_speed: float = 10 
@export var jump_velocity: float = 10.0
@export var acceleration: float = 10.0 # 移动平滑过渡系数

@export_category("Camera")
@export var mouse_sensitivity: float = 0.002 # 鼠标灵敏度 (弧度制)

@export_category("Audio")
@export var footstep_interval: float = 0.5 # 每步之间的基础间隔时间 (秒)

# ==========================================
# 节点引用
# ==========================================
@onready var camera: Camera3D = $Camera3D
# 确保在 CharacterBody3D 下添加了一个名为 FootstepPlayer 的 AudioStreamPlayer3D 节点
@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer

# 运行时变量
var current_speed: float = walk_speed
var footstep_timer: float = 0.0

func _ready() -> void:
	# 隐藏并捕获鼠标
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# ==========================================
# 输入事件处理 (处理鼠标视角与 UI 逻辑)
# ==========================================
func _unhandled_input(event: InputEvent) -> void:
	# 1. 鼠标移动控制视角旋转
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# 水平移动鼠标 -> 旋转角色身体 (偏航角 Yaw)
		rotate_y(-event.relative.x * mouse_sensitivity)
		# 垂直移动鼠标 -> 仅旋转摄像机头部 (俯仰角 Pitch)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		# 限制摄像机抬头低头的最大角度 (-60度到60度)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

	## 2. 暂停/呼出菜单逻辑
	#if event.is_action_pressed("ui_cancel"):
		#pause_screen.show_pause()

# ==========================================
# 物理与移动核心逻辑 (固定帧率执行)
# ==========================================
func _physics_process(delta: float) -> void:
	# 1. 重力处理
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. 跳跃处理
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# 3. 速度切换
	# 我帮你取消了注释，这样冲刺时脚步声才会变快。
	# 如果你的 Input Map 里还没加 "speed_up" 这个动作，记得加上，否则运行时会报错。
	if Input.is_action_pressed("speed_up"):
		current_speed = sprint_speed
	else:
		current_speed = walk_speed

	# 4. 获取输入方向并映射到 3D 空间
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# 结合角色当前的朝向 (transform.basis) 计算实际移动向量
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 5. 平滑过渡到目标速度
	var target_velocity_x = direction.x * current_speed
	var target_velocity_z = direction.z * current_speed
	
	velocity.x = move_toward(velocity.x, target_velocity_x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velocity_z, acceleration * delta)

	# 6. 调用内置方法执行实际移动与碰撞
	move_and_slide()
	
	# 7. 处理脚步声
	_handle_footsteps(delta, direction)

# ==========================================
# 自定义辅助方法
# ==========================================
# ==========================================
# 适用于“长段连续脚步声”的逻辑
# ==========================================
func _handle_footsteps(_delta: float, direction: Vector3) -> void:
	var is_moving = is_on_floor() and direction.length() > 0 and Vector2(velocity.x, velocity.z).length() > 0.1
	
	if is_moving:
		# 如果还没有在播放，就开始播放
		if not footstep_player.playing:
			footstep_player.play()
			
		# 根据是走路还是冲刺，调整长音效的播放速度
		if current_speed > walk_speed:
			footstep_player.pitch_scale = 1.3 # 跑得快，播放速度变快 (具体数值根据你的音频微调)
		else:
			footstep_player.pitch_scale = 1.0 # 正常速度
	else:
		# 没在移动，或者在空中，立刻停止播放
		if footstep_player.playing:
			footstep_player.stop()

# ==============================
# 爱心加速功能（新增）
# ==============================
func start_boost(boost_speed: float, duration: float):
	# 保存原来的速度
	var original_walk = walk_speed
	var original_sprint = sprint_speed
	
	# 临时加速
	walk_speed = boost_speed
	sprint_speed = boost_speed
	current_speed = boost_speed
	
	# 等待5秒后恢复
	await get_tree().create_timer(duration).timeout
	
	# 恢复原来的速度
	walk_speed = original_walk
	sprint_speed = original_sprint
	current_speed = original_walk
