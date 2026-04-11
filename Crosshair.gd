#@tool  # 加了这个在编辑器里也能直接看到准星，不用运行游戏
extends Control # 准星通常不需要 Container 的功能，Control 更纯净

@export var DOT_RADIUS : float = 3.0:
	set(value):
		DOT_RADIUS = value
		queue_redraw() # 属性改变时自动重绘

@export var DOT_COLOR : Color = Color.WHITE:
	set(value):
		DOT_COLOR = value
		queue_redraw()

func _draw():
	# 使用相对中心的坐标 (0,0)
	# 如果这个节点放在 Screen Center，它就会在正中央
	var center = Vector2.ZERO 
	draw_circle(center, DOT_RADIUS, DOT_COLOR)

# 如果想做更复杂的准星（比如十字架），可以在这里继续添加 draw_line
