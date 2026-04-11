extends MeshInstance3D

# 仅设置门的形状，不动位置！绝对不会消失！
@export var door_size: Vector3 = Vector3(3.0, 4.0, 0.3)

func _ready():
	# 创建方块网格
	var door_mesh: BoxMesh = BoxMesh.new()
	# 设置成正常门板大小
	door_mesh.size = door_size
	# 赋值给门，只改形状，不改位置！
	mesh = door_mesh
