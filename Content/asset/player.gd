extends CharacterBody3D

signal coin_collected

@export_category("Movement Settings")
@export var movement_speed: float = 5.0
@export var jump_velocity: float = 3.0
@export var mouse_sensitivity: float = 0.003 # 鼠标灵敏度

# ==========================================
# 节点引用
# ==========================================
@onready var character_model = $Character
@onready var animation = $Character/AnimationPlayer
@onready var camera_pivot = $CameraPivot # 相机枢轴
@onready var sound_footsteps = $SoundFootsteps
@onready var particles_trail = $ParticlesTrail

# ==========================================
# 状态变量
# ==========================================
var can_double_jump: bool = false
var previously_floored: bool = false
var coins: int = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# 加速相关变量
var boost_remaining_time: float = 0.0
var is_boost_active: bool = false
var original_movement_speed: float
var boost_timer_label: Label

func _ready():
	# 启动时锁死鼠标
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# 自动寻找 UI 节点
	boost_timer_label = get_node_or_null("../UICanvas/BoostTimerLabel")
	if boost_timer_label != null:
		boost_timer_label.visible = false

func _unhandled_input(event):
	# 鼠标控制相机旋转逻辑
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_object_local(Vector3.RIGHT, -event.relative.y * mouse_sensitivity)
		# 限制俯仰角，防止相机翻转
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-80), deg_to_rad(60))
		camera_pivot.rotation.z = 0 

func _physics_process(delta):
	# 1. 处理加速倒计时逻辑
	if is_boost_active:
		boost_remaining_time -= delta
		if boost_timer_label != null:
			boost_timer_label.text = "加速剩余: %.1f 秒" % boost_remaining_time
		
		# 时间到，恢复速度
		if boost_remaining_time <= 0:
			is_boost_active = false
			_reset_boost_speed()
			if boost_timer_label != null:
				boost_timer_label.visible = false

	# 2. 处理重力与跳跃
	handle_gravity_and_jump(delta)
	
	# 3. 处理移动
	handle_movement(delta)
	
	# 4. 执行位移
	move_and_slide()
	
	# 5. 处理动画、脚步声与落地特效
	handle_landing_effects(delta)
	handle_animations()
	
	previously_floored = is_on_floor()

# ----------------- 功能逻辑函数 -----------------

func handle_gravity_and_jump(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		can_double_jump = true

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			perform_jump()
		elif can_double_jump:
			perform_jump()
			can_double_jump = false

func perform_jump():
	# 起跳瞬间立刻强行关闭脚步声，防止空中播放
	if sound_footsteps.playing:
		sound_footsteps.stop()
	
	velocity.y = jump_velocity
	
	# 这里可以替换为你真实的跳跃音效路径
	# Audio.play("res://Content/asset/jump.ogg") 
	
	character_model.scale = Vector3(0.5, 1.5, 0.5)

func handle_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# 根据相机朝向决定移动方向
	var direction = (camera_pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0 
	direction = direction.normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * movement_speed, delta * 15.0)
		velocity.z = lerp(velocity.z, direction.z * movement_speed, delta * 15.0)
		
		# 修正模型朝向，解决“太空步”问题
		var target_rotation = atan2(direction.x, direction.z)
		character_model.rotation.y = lerp_angle(character_model.rotation.y, target_rotation, delta * 15.0)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 15.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 15.0)

func handle_landing_effects(delta):
	# 模型缩放平滑恢复
	character_model.scale = character_model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# 落地瞬间特效
	if is_on_floor() and not previously_floored:
		character_model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://Content/asset/walking.ogg") 

func handle_animations():
	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	
	# 增加一个垂直速度判断，确保跳跃瞬间声音消失
	var is_jumping = abs(velocity.y) > 0.5

	if is_on_floor() and not is_jumping:
		if horizontal_speed > 0.5:
			if animation.current_animation != "walk":
				animation.play("walk", 0.1)
			
			var speed_factor = horizontal_speed / 6.0 # 以基础速度为基准
			animation.speed_scale = speed_factor
			particles_trail.emitting = (speed_factor > 0.75)
			
			# 走路时播放脚步声
			if not sound_footsteps.playing:
				sound_footsteps.play()
			sound_footsteps.pitch_scale = max(0.5, speed_factor)
		else:
			# 站在地上不动
			if animation.current_animation != "idle":
				animation.play("idle", 0.1)
			particles_trail.emitting = false
			if sound_footsteps.playing:
				sound_footsteps.stop()
	else:
		# 在空中（跳跃或坠落）
		particles_trail.emitting = false
		if sound_footsteps.playing:
			sound_footsteps.stop() 
		if animation.current_animation != "jump":
			animation.play("jump", 0.1)

# ==========================================
# 爱心加速接口
# ==========================================
func start_boost(boost_speed: float, duration: float):
	if not is_boost_active:
		original_movement_speed = movement_speed
	
	movement_speed = boost_speed
	boost_remaining_time = duration
	is_boost_active = true
	
	if boost_timer_label != null:
		boost_timer_label.visible = true
		boost_timer_label.text = "加速剩余: %.1f 秒" % boost_remaining_time

func _reset_boost_speed():
	movement_speed = original_movement_speed

# ==========================================
# 其他功能
# ==========================================
func collect_coin():
	coins += 1
	coin_collected.emit(coins)
