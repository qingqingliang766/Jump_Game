extends Control

# 核心配置：把你的第一关场景路径填在这里
# 提示：你可以直接从左侧文件系统把 level1.scn 拖到引号里
@export var start_level_path: String = "uid://ckkpnx4r3shv2"

func _ready() -> void:
	# 确保进入菜单时鼠标是可见的，否则玩家没法点按钮
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# 让按钮获得焦点（这样可以用键盘上下键选，更专业）
	$MarginContainer/VBoxContainer/Play_Button.grab_focus()

# “开始游戏”按钮的逻辑
func _on_play_button_pressed() -> void:
	# 先检查游戏是否处于暂停状态
	if get_tree().paused:
		# 如果是暂停，我们只需要“恢复”
		get_tree().paused = false
		self.hide() # 隐藏菜单
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # 重新锁住鼠标
		print("恢复游戏运行")
	else:
		# 如果没暂停（比如刚启动），才执行跳转场景
		if start_level_path == "":
			print("错误：路径为空")
			return
		get_tree().change_scene_to_file(start_level_path)

# “退出游戏”按钮的逻辑
func _on_exit_button_pressed() -> void:
	# 直接退出程序
	get_tree().quit()
