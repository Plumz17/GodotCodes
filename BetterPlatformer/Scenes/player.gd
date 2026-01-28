extends CharacterBody2D

@export_category("Basic Movement")
@export var speed: float = 150
@export var jump_velocity: float = -270
@export var terminal_velocity: float = 500
@export var fall_speed: float = 980

@export_category("Buffer Jump")
@export var jump_buffer_time: float = 0.1

@export_category("Coyote Time")
@export var coyote_time: float = 0.1

@export_category("Variable Jump Height")
@export var gravity_modifier: float = 8


@onready var debug_label: Label = $DebugLabel
@onready var buffer_timer: Timer = $BufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var sprite: AnimatedSprite2D = $Sprite

# Buffer Jump
var jump_available: bool = true
var buffer_jump: bool = false

func _ready() -> void:
	buffer_timer.wait_time = jump_buffer_time
	coyote_timer.wait_time = coyote_time

func _physics_process(delta: float) -> void:
	update_debug_label()
	handle_fall(delta)
	handle_jump()
	handle_movement()
	handle_flip()
	handle_anim()
	
	velocity.y = clampf(velocity.y, jump_velocity, terminal_velocity)
	move_and_slide()

func handle_fall(delta: float) -> void:
	var current_fall_speed: float
	if Input.is_action_just_released("jump") and !is_on_floor():
		current_fall_speed = fall_speed * gravity_modifier
	else:
		current_fall_speed = fall_speed
	velocity.y += delta * current_fall_speed

func handle_jump() -> void:
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
	text += "VEL: %v" % velocity
	debug_label.text = text

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _on_buffer_timer_timeout() -> void:
	buffer_jump = false

func _on_coyote_timer_timeout() -> void:
	pass # Replace with function body.
