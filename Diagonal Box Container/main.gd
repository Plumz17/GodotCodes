extends Control

@export var pitch_step: float = 0.1
@export var pitch_base: float = 1.0
@export var pitch_max: float = 1.5
@onready var sound: AudioStreamPlayer2D = $Sound
var count: int = 0
var pitch: float = pitch_base


func _enter_tree() -> void:
	SignalHub.on_button_hover.connect(on_button_hover)

func on_button_hover() -> void:
	pitch = min(pitch + pitch_step, pitch_max)
	if sound.playing == false:
		pitch = pitch_base
	sound.pitch_scale = pitch
	sound.play()

func _process(delta: float) -> void:
	print(pitch)
