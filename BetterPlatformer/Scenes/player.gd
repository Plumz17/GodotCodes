extends CharacterBody2D

@export_category("Basic Movement")
@export var speed: float = 100
@export var jump_velocity: float = -400

@export_category("Buffer Jump")
@export var jump_buffer_time: float = 1.0

@export_category("Buffer Jump")

@onready var debug_label: Label = $DebugLabel
@onready var buffer_timer: Timer = $BufferTimer

# Buffer Jump
var jump_available: bool = true
var buffer_jump: bool = false

const GRAVITY = 98.0

func _ready() -> void:
	buffer_timer.wait_time = jump_buffer_time

func _physics_process(delta: float) -> void:
	update_debug_label()

	velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("jump"):
		if jump_available:
			jump()
		else: #If jump unavailable
			buffer_jump = true
			buffer_timer.start()
	
	if is_on_floor():
		if buffer_jump:
			jump()
			buffer_jump = false

	var direction := Input.get_axis("left", "right")
	velocity.x = direction * speed
	move_and_slide()
	
func jump() -> void:
	velocity.y = jump_velocity
	jump_available = false
	
func update_debug_label() -> void:
	var text: String = ""
	text += "BUFF: %.2f\n" % buffer_timer.time_left
	text += "VEL: %v" % velocity
	debug_label.text = text


func _on_buffer_timer_timeout() -> void:
	buffer_jump = false
