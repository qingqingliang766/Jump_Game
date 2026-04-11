extends Area3D

@onready var default_spawn_point: Marker3D = $"../DefaultSpawnPoint"

func _on_body_entered(body: Node3D) -> void:
	# 只要进来的东西是 CharacterBody3D 类型（也就是你的玩家）
	if body is CharacterBody3D:
		# 1. 检查有没有指定重生点，没指定就报错提醒
		print("碰到死亡点")
		if default_spawn_point == null:
			print("警告：你还没给死亡区指定 Marker3D 重生点！")
			return
		
		# 2. 【核心】像上帝一样强行修改玩家的位置
		body.global_position = default_spawn_point.global_position
		
		# 3. 【关键】强行重置玩家的速度
		# body 就是玩家实例，我们可以直接改它的 velocity 属性
		body.velocity = Vector3.ZERO
		
		print("捕获到玩家，已强行将其送回起点")
