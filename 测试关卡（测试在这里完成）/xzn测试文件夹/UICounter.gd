extends Control

# 🔴 自动获取金币数显示的Label节点
@onready var coin_label: Label = $CoinLabel

func _ready():
	# 🔴 连接全局单例的「金币数变化」信号，自动更新UI
	Global.coin_count_changed.connect(_on_coin_count_changed)
	# 🔴 初始化显示，打开游戏就显示当前金币数
	_on_coin_count_changed(Global.coin_count)

# 🔴 金币数变化时，自动更新Label的文字
func _on_coin_count_changed(new_count: int):
	coin_label.text = "金币: " + str(new_count)
