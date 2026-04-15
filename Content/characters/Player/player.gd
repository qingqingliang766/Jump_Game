extends CharacterBody3D

# ==========================================
# 导出参数 (在属性面板调节)
# ==========================================
@export_category("Movement")
@export var walk_speed: float = 8.0
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
@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer

# 运行时变量
var current_speed: float = walk_speed
var footstep_timer: float = 0.0

# 🔥 加速相关变量
var boost_remaining_time: float = 0.0
var is_boost_active: bool = false
var original_walk_speed: float
var original_sprint_speed: float

# 🔥 UI节点引用（自动找，不用手动拖）
@onready var boost_timer_label: Label

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# 🔥 自动找到UI节点，完全不用手动绑定
	boost_timer_label = get_node("/root/Test/UICanvas/BoostTimerLabel")
	
	# 初始化隐藏文字
	if boost_timer_label != null:
		boost_timer_label.visible = false
		print("UI节点绑定成功！")
	else:
		print("错误：找不到UI节点，请检查场景名是否为Test")

# ==========================================
# 输入事件处理
# ==========================================
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

# ==========================================
# 物理与移动核心逻辑
# ==========================================
func _physics_process(delta: float) -> void:
	# 重力
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 跳跃
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# 🔥 加速倒计时（实时更新UI）
	if is_boost_active:
		boost_remaining_time -= delta
		if boost_timer_label != null:
			boost_timer_label.text = "加速剩余: %.1f 秒" % boost_remaining_time
		
		# 时间到，恢复速度+隐藏文字
		if boost_remaining_time <= 0:
			is_boost_active = false
			_reset_boost_speed()
			if boost_timer_label != null:
				boost_timer_label.visible = false

	# 速度切换（优先使用加速）
	if is_boost_active:
		current_speed = walk_speed
	else:
		if Input.is_action_pressed("speed_up"):
			current_speed = sprint_speed
		else:
			current_speed = walk_speed

	# 输入方向
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 平滑移动
	var target_velocity_x = direction.x * current_speed
	var target_velocity_z = direction.z * current_speed
	velocity.x = move_toward(velocity.x, target_velocity_x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velocity_z, acceleration * delta)

	move_and_slide()
	_handle_footsteps(delta, direction)

# ==========================================
# 脚步声
# ==========================================
func _handle_footsteps(_delta: float, direction: Vector3) -> void:
	var is_moving = is_on_floor() and direction.length() > 0 and Vector2(velocity.x, velocity.z).length() > 0.1
	
	if is_moving:
		if not footstep_player.playing:
			footstep_player.play()
		footstep_player.pitch_scale = 1.3 if current_speed > walk_speed else 1.0
	else:
		if footstep_player.playing:
			footstep_player.stop()

# ==============================
# 🔥 爱心加速功能
# ==============================
func start_boost(boost_speed: float, duration: float):
	print("捡到爱心！加速开启，持续", duration, "秒")
	
	# 保存原始速度
	original_walk_speed = walk_speed
	original_sprint_speed = sprint_speed
	
	# 开启加速
	walk_speed = boost_speed
	sprint_speed = boost_speed
	boost_remaining_time = duration
	is_boost_active = true
	
	# 显示UI文字
	if boost_timer_label != null:
		boost_timer_label.visible = true
		boost_timer_label.text = "加速剩余: %.1f 秒" % boost_remaining_time

func _reset_boost_speed():
	# 恢复原始速度
	walk_speed = original_walk_speed
	sprint_speed = original_sprint_speed
	current_speed = original_walk_speed
	print("加速结束，速度恢复")
