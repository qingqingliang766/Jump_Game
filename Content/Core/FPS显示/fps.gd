extends CanvasLayer


func _process(_delta: float) -> void:
	$Label.text = str("FPS:",Engine.get_frames_per_second())
