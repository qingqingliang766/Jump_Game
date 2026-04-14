extends Area3D

# 1. 自动获取下面的音效播放器（节点名字必须叫 AudioStreamPlayer3D）
@onready var sound_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		# 2. 播放音效
		sound_player.play()
		
		# 3. 先计数，再删除
		Global.add_diamond()
		
		# 4. 关键！等待音效播完再删除对象 (0.5秒是音效默认长度)
		await get_tree().create_timer(0.5).timeout
		
		# 5. 删除整个钻石（父节点）
		get_parent().queue_free()
