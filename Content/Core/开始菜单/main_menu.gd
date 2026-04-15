extends Control

@export var start_level_path: String = "uid://ckkpnx4r3shv2"
@export var button_anim_speed: float = 0.2
@export var fade_in_duration: float = 0.5

# ===== 背景配置参数（直接在编辑器里改颜色） =====
@export var bg_color: Color = Color(0.1, 0.1, 0.15, 0.8) # 深紫蓝半透明
@export var bg_anim_speed: float = 0.8
# ================================================

@onready var play_btn: Button = $VBoxContainer/Play_Button
@onready var exit_btn: Button = $VBoxContainer/Exit_Button
@onready var vbox: VBoxContainer = $VBoxContainer
@onready var background: TextureRect = $MarginContainer/Background # 新增背景引用

var is_loading: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	play_btn.grab_focus()
	
	# 1. 初始化：背景淡入
	background.modulate = Color(1,1,1,0)
	var tween_bg = create_tween()
	tween_bg.tween_property(background, "modulate:a", 1.0, bg_anim_speed)
	tween_bg.set_ease(Tween.EASE_OUT)
	
	# 2. 按钮淡入
	vbox.modulate = Color(1,1,1,0)
	var tween_vbox = create_tween()
	tween_vbox.tween_property(vbox, "modulate:a", 1.0, fade_in_duration)
	tween_vbox.set_ease(Tween.EASE_OUT)
	
	# 3. 绑定按钮动画
	play_btn.mouse_entered.connect(func(): _on_btn_hover(play_btn))
	play_btn.mouse_exited.connect(func(): _on_btn_leave(play_btn))
	exit_btn.mouse_entered.connect(func(): _on_btn_hover(exit_btn))
	exit_btn.mouse_exited.connect(func(): _on_btn_leave(exit_btn))

# 按钮悬停
func _on_btn_hover(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.1, 1.1), button_anim_speed)
	tween.set_ease(Tween.EASE_OUT)

# 按钮离开
func _on_btn_leave(btn: Button):
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1, 1), button_anim_speed)
	tween.set_ease(Tween.EASE_OUT)

# 开始游戏
func _on_play_button_pressed() -> void:
	if is_loading: return
	is_loading = true
	
	# === 暂停状态下的恢复逻辑 ===
	if get_tree().paused:
		# 不要在这里自己写恢复逻辑了！
		# 直接找到根节点 (level_1)，让它来统管恢复（它会顺便把 BGM 也恢复了）
		var level_node = get_tree().current_scene
		if level_node.has_method("toggle_pause"):
			level_node.toggle_pause() 
			
		is_loading = false
		return
	
	# === 正常主菜单下进入关卡的逻辑 (保持不变) ===
	if start_level_path == "":
		print("错误：关卡路径为空！")
		is_loading = false
		return
	
	var tween = create_tween()
	tween.tween_property(vbox, "modulate:a", 0.0, fade_in_duration)
	tween.finished.connect(func():
		get_tree().change_scene_to_file(start_level_path)
		is_loading = false
	)

# 退出游戏
func _on_exit_button_pressed() -> void:
	if is_loading: return
	get_tree().quit()

# 窗口适配
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		$MarginContainer.anchor_right = 1.0
		$MarginContainer.anchor_bottom = 1.0
		$MarginContainer.offset_right = 0
		$MarginContainer.offset_bottom = 0
