extends Node

# 全局金币数
@export var coin_count: int = 0

# 钻石数量
@export var diamond_count: int = 0

# 单例
static var instance

# 信号
signal coin_count_changed(new_count: int)
signal diamond_count_changed(new_count: int)

func _ready():
	if instance == null:
		instance = self
	else:
		queue_free()

# 加金币
func add_coin(amount: int = 1):
	coin_count += amount
	coin_count_changed.emit(coin_count)

# 加钻石
func add_diamond(amount: int = 1):
	diamond_count += amount
	diamond_count_changed.emit(diamond_count)

# 重置金币
func reset_coin():
	coin_count = 0
	coin_count_changed.emit(coin_count)
