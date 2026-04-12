extends Label

func _ready():
	# 连接钻石计数信号
	Global.diamond_count_changed.connect(_update_text)
	# 开局显示0
	_update_text()

# 更新文字
func _update_text():
	text = "钻石：" + str(Global.diamond_count)
