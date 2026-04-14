extends Label

func _ready():
	# 连接信号，信号会自动传新的钻石数
	Global.diamond_count_changed.connect(_update)
	# 初始化显示
	_update(Global.diamond_count)

# 修复2：给函数加参数，接收信号传过来的新数值
func _update(new_count: int):
	text = "钻石：" + str(new_count)
