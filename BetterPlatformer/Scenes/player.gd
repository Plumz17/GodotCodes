extends CharacterBody2D

@export_category("Basic Movement")
@export var speed: float = 150
@export var jump_velocity: float = -270
@export var terminal_velocity: float = 500
@export var default_gravity: float = 980

@export_category("Buffer Jump")
@export var jump_buffer_time: float = 0.1

@export_category("Coyote Time")
@export var coyote_time: float = 0.1

@export_category("Variable Jump Height")
@export var gravity_modifier: float = 2

@onready var debug_label: Label = $DebugLabel
@onready var buffer_timer: Timer = $BufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var sprite: AnimatedSprite2D = $Sprite

# Buffer Jump & Coyote Time
var jump_available: bool = true
var jump_buffer: bool = false

# Current Gravity
var current_gravity: float = 0

func _ready() -> void:
	buffer_timer.wait_time = jump_buffer_time
	coyote_timer.wait_time = coyote_time
	current_gravity = default_gravity
	Engine.time_scale = 0.2

func _physics_process(delta: float) -> void:
	update_debug_label()
	handle_fall(delta)
	handle_jump()
	handle_movement()
	handle_flip()
	handle_anim()
	
	if velocity.y > terminal_velocity:
		velocity.y = terminal_velocity
	move_and_slide()

func handle_fall(delta: float) -> void:
	if !is_on_floor():
		if jump_available and coyote_timer.is_stopped():
			coyote_timer.start()
		
		if velocity.y < 0 and Input.is_action_just_released("jump"): # If Falling
			current_gravity = default_gravity * gravity_modifier
			
		velocity.y += current_gravity * delta
	else:
		jump_available = true
		current_gravity = default_gravity
		coyote_timer.stop()

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and jump_available:
		jump()

func handle_movement() -> void:
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * speed

func handle_anim() -> void:
	if !is_zero_approx(velocity.x):
		sprite.play("move")
	else:
		sprite.play("idle")

func handle_flip() -> void:
	if !is_zero_approx(velocity.x):
		sprite.flip_h = velocity.x <= 0

func jump() -> void:
	velocity.y = jump_velocity
	jump_available = false
	
func update_debug_label() -> void:
	var text: String = ""
	text += "BUFF: %.2f\n" % buffer_timer.time_left
	text += "COY: %.2f\n" % coyote_timer.time_left
	text += "GRAV: %.2f," % current_gravity
	text += "AVA: %s" % jump_available
	debug_label.text = text

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _on_coyote_timer_timeout() -> void:
	jump_available = false
