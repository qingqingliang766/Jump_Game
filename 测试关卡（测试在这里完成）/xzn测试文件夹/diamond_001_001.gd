extends MeshInstance3D

# 自动获取碰撞区域
@onready var area: Area3D = $Area3D

func _ready():
	# 连接触碰信号
	area.body_entered.connect(_on_player_touch)

# 玩家碰到就执行
func _on_player_touch(body):
	# 只识别玩家（和你金币一样的判断）
	if body.name == "Player":
		# 钻石数量+1
		Global.add_diamond()
		# 钻石消失
		queue_free()
