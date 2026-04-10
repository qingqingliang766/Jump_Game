extends Node3D

@onready var bgm_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	bgm_player.play()
