extends Node3D

@export var move_speed: float = 0.9
@export var move_height: float = 3.5
@export var start_offset: float = 0.0

var start_y: float

func _ready():
	start_y = position.y + start_offset

func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var new_y = start_y + (move_height / 2) * sin(time * move_speed)
	position.y = new_y
