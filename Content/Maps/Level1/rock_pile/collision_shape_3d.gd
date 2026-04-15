# 注意：脚本不要挂在 CollisionShape3D 上！
# 脚本要挂在 StaticBody3D 上！

extends StaticBody3D

func _ready():
	# 找到子节点 CollisionShape3D
	var collision = $CollisionShape3D
	
	# 创建盒子碰撞
	var box = BoxShape3D.new()
	box.size = Vector3(2, 2, 2)
	
	# 设置碰撞形状
	collision.shape = box
