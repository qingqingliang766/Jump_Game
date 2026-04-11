extends Node3D

@onready var bgm_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	bgm_player.play()
	# 确保一进游戏就锁死鼠标
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

@onready var pause_menu = $"CanvasLayer/开始菜单" # 替换成你菜单节点的实际路径

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"): # 之前设置的 ESC 键
		toggle_pause()

func toggle_pause():
	# 1. 切换引擎的暂停状态
	# !get_tree().paused 的意思就是“取反”，如果现在没停就停，停了就恢复
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused 
	
	# 2. 处理 UI 的显示和隐藏
	if is_paused:
		pause_menu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # 释放鼠标
		# 专家建议：让第一个按钮获得焦点，方便手柄或键盘操作
		pause_menu.get_node("MarginContainer/VBoxContainer/Play_Button").grab_focus()
	else:
		pause_menu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # 重新锁死鼠标
