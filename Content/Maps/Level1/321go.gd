extends Control

@onready var countdown_label: Label = $countdownlabel
@onready var countdown_timer: Timer = $countdowntimer

var current_count = 3

func _ready():
	countdown_label.visible = true
	countdown_label.text = ""
	countdown_timer.timeout.connect(_on_timer_timeout)
	update_count()
	countdown_timer.start()

func _on_timer_timeout():
	current_count -= 1
	update_count()

func update_count():
	if current_count > 0:
		countdown_label.text = str(current_count)
		play_anim()
	else:
		countdown_label.text = "GO!"
		countdown_label.modulate = Color(1, 1, 0)
		play_anim()
		countdown_timer.stop()
		# 1秒后隐藏GO!
		var hide_timer = Timer.new()
		hide_timer.wait_time = 1.0
		hide_timer.autostart = true
		hide_timer.one_shot = true
		hide_timer.timeout.connect(func():
			countdown_label.visible = false
			hide_timer.queue_free()
		)
		add_child(hide_timer)

func play_anim():
	var tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2(1.6, 1.6), 0.15)
	tween.tween_property(countdown_label, "scale", Vector2(1, 1), 0.15)
	tween.finished.connect(func():
		if countdown_label.text != "GO!":
			countdown_label.modulate = Color(1, 1, 1)
	)
