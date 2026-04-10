extends CharacterBody3D

# ==========================================
# 导出参数 (在属性面板调节)
# ==========================================
@export_category("Movement")
@export var walk_speed: float = 8.0
@export var sprint_speed: float = 4.5
@export var jump_velocity: float = 5.0
@export var acceleration: float = 10.0 # 移动平滑过渡系数

@export_category("Camera")
@export var mouse_sensitivity: float = 0.002 # 鼠标灵敏度 (弧度制)

# ==========================================
# 节点引用
# ==========================================
@onready var camera: Camera3D = $Camera3D

# 运行时变量
var current_speed: float = walk_speed

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

	## 3. 速度切换 (按住加速键使用冲刺速度)
	#current_speed = sprint_speed if Input.is_action_pressed("speed_up") else walk_speed

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
