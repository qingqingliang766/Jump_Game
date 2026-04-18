extends Node3D

@export_category("References")
@export var target: Node3D # 必须在面板里把 Player 拖进来

@export_category("Settings")
@export var mouse_sensitivity: float = 0.003
@export var follow_speed: float = 10.0

@export_category("Zoom")
@export var zoom_min: float = 2.0  # 最近距离
@export var zoom_max: float = 16.0 # 最远距离
@export var zoom_speed: float = 1.0

var cam_yaw: float = 0.0   # 水平旋转角度
var cam_pitch: float = 0.0 # 垂直旋转角度
var current_zoom: float = 8.0

@onready var camera = $Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam_yaw = rotation.y
	cam_pitch = rotation.x
	current_zoom = camera.position.z

func _unhandled_input(event):
	# 1. 鼠标旋转视角
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cam_yaw -= event.relative.x * mouse_sensitivity
		cam_pitch -= event.relative.y * mouse_sensitivity
		# 限制抬头低头角度 (-80度 到 -10度)
		cam_pitch = clamp(cam_pitch, deg_to_rad(-80), deg_to_rad(-10))

	# 2. 滚轮缩放
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_zoom -= zoom_speed
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_zoom += zoom_speed
		# 注意：clamp 的第二个参数必须是小的，第三个参数必须是大的
		current_zoom = clamp(current_zoom, zoom_min, zoom_max)

func _physics_process(delta):
	if target == null: return # 防报错
	
	# 1. 位置平滑跟随
	global_position = global_position.lerp(target.global_position, delta * follow_speed)
	
	# 2. 角度平滑旋转
	rotation.y = lerp_angle(rotation.y, cam_yaw, delta * 15.0)
	rotation.x = lerp_angle(rotation.x, cam_pitch, delta * 15.0)
	
	# 3. 相机距离平滑缩放
	camera.position.z = lerp(camera.position.z, current_zoom, delta * 10.0)
