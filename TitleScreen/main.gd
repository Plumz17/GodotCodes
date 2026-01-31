extends Control

@export var pitch_step: float = 0.1
@export var pitch_base: float = 1.0
@export var pitch_max: float = 1.5
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound
@onready var click_sound: AudioStreamPlayer2D = $ClickSound
@onready var diagonal_container: DiagonalContainer = $ButtonsContainer/DiagonalContainer
@onready var circular_container: CircularContainer = $CreditsContainer/CircularContainer
@onready var logo_container: MarginContainer = $LogoContainer
@onready var buttons_container: MarginContainer = $ButtonsContainer
@onready var credits_container: MarginContainer = $CreditsContainer
@onready var back_container: MarginContainer = $BackContainer

var count: int = 0
var pitch: float = pitch_base

#func _enter_tree() -> void:
	#SignalHub.on_button_hover.connect(on_button_hover)

func _ready() -> void:
	for c: GameButton in diagonal_container.get_children():
		c.on_button_hover.connect(on_button_hover)
		c.on_button_pressed.connect(on_button_pressed)
	for c: GameButton in circular_container.get_children():
		c.on_button_hover.connect(on_button_hover)
	
	var back: GameButton = back_container.get_child(0)
	back.on_button_hover.connect(on_button_hover)
	back.on_button_pressed.connect(on_button_pressed)
	
	#if diagonal_container.get_child_count() > 0:
		#diagonal_container.get_child(0).grab_button_focus()

func on_button_hover() -> void:
	pitch = min(pitch + pitch_step, pitch_max)
	if hover_sound.playing == false:
		pitch = pitch_base
	hover_sound.pitch_scale = pitch
	hover_sound.play()
	
func on_button_pressed(action_id: String) -> void:
	click_sound.play()
	match action_id:
		"start":
			start_game()
		"credits":
			load_credits(true)
		"exit":
			get_tree().quit()
		"back":
			load_credits(false)
			
func start_game() -> void:
	print("Start")

func load_credits(b: bool) -> void:
	logo_container.visible = !b
	buttons_container.visible = !b
	credits_container.visible = b
	back_container.visible = b
	#if b and circular_container.get_child_count() > 0:
		#circular_container.get_child(0).grab_button_focus()
	#if !b and diagonal_container.get_child_count() > 0:
		#diagonal_container.get_child(0).grab_button_focus()
