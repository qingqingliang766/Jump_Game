extends Node3D

@export var 底部固定点: Vector3 = Vector3(0, 0, 0)
@export var 摆动速度: float = 2.0
@export var 最大摆角: float = 25.0
@export var 摆长: float = 1.5

var timer: float = 0.0

func _process(delta: float) -> void:
	timer += delta * 摆动速度
	var angle = deg_to_rad(sin(timer) * 最大摆角)
	var offset_x = sin(angle) * 摆长
	var offset_y = cos(angle) * 摆长
	global_position = 底部固定点 + Vector3(offset_x, offset_y, 0)
	look_at(底部固定点, Vector3.UP)
