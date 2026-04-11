extends Area3D

# 引用UI节点（需要在场景中创建）
@onready var success_ui = $"/root/Test/SuccessUI"
# 动画播放器（需要给Area3D添加AnimationPlayer子节点）
@onready var anim_player = $AnimationPlayer
# 粒子特效（需要给Area3D添加GPUParticles3D子节点）
@onready var particles = $GPUParticles3D
# 音效播放器（需要给Area3D添加AudioStreamPlayer子节点）
@onready var audio_player = $AudioStreamPlayer

func _on_body_entered(body: Node3D) -> void:
	# 检测是否是玩家
	if body.name == "Player":
		# 1. 播放收集音效
		audio_player.play()
		# 2. 播放粒子特效
		particles.emitting = true
		# 3. 播放皇冠消失动画
		anim_player.play("collect")
		# 4. 显示闯关成功UI
		show_success_ui()
		# 5. 动画结束后销毁皇冠
		await anim_player.animation_finished
		get_parent().queue_free()

# 显示闯关成功UI
func show_success_ui() -> void:
	# 让UI可见
	success_ui.visible = true
	# 播放UI淡入动画
	success_ui.get_node("AnimationPlayer").play("fade_in")
	# 3秒后自动淡出
	await get_tree().create_timer(3.0).timeout
	success_ui.get_node("AnimationPlayer").play("fade_out")
	# 淡出后隐藏UI
	await success_ui.get_node("AnimationPlayer").animation_finished
	success_ui.visible = false
