extends Node

# 全局金币数，初始为0，@export可在检查器修改
@export var coin_count: int = 0

# 单例实例（省略类型标注，彻底解决类型找不到的问题）
static var instance

# 信号：金币数变化时通知UI更新
signal coin_count_changed(new_count: int)

func _ready():
	# 单例初始化，确保全局唯一
	if instance == null:
		instance = self
	else:
		queue_free()

# 加金币方法，默认+1，支持自定义数量
func add_coin(amount: int = 1):
	coin_count += amount
	coin_count_changed.emit(coin_count)

# 重置金币数（重开游戏用）
func reset_coin():
	coin_count = 0
	coin_count_changed.emit(coin_count)
