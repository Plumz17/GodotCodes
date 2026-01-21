extends Control

@export var pitch_step: float = 0.1
@export var pitch_base: float = 1.0
@export var pitch_max: float = 1.5
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var diagonal_container: DiagonalContainer = $DiagonalContainer

var count: int = 0
var pitch: float = pitch_base

func _enter_tree() -> void:
	SignalHub.on_button_hover.connect(on_button_hover)

func _ready() -> void:
	if diagonal_container.get_child_count() > 0:
		diagonal_container.get_child(0).grab_button_focus()

func on_button_hover() -> void:
	pitch = min(pitch + pitch_step, pitch_max)
	if sound.playing == false:
		pitch = pitch_base
	sound.pitch_scale = pitch
	sound.play()
