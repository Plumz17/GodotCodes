extends Control
class_name GameButton

@export var action_id: String
@export var move_length: Vector2 = Vector2(0, -10)
@export var scale_size: Vector2 = Vector2(1.5, 1.5)
@onready var texture_button: TextureButton = $TextureButton
signal on_button_hover
signal on_button_pressed(action_id)


var original_scale: Vector2
var original_position: Vector2
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_scale = texture_button.scale
	original_position = texture_button.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tween_button_entered() -> void:
	if tween:
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.tween_property(texture_button, "position", original_position + move_length, 0.1)
	tween.tween_property(texture_button, "scale", original_scale * scale_size, 0.1)
	z_index += 1

func tween_button_exitted() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(texture_button, "scale", original_scale, 0.1)
	tween.tween_property(texture_button, "position", original_position, 0.1)
	tween.set_parallel(false)
	z_index = 0

func grab_button_focus() -> void:
	texture_button.grab_focus()

func _on_texture_button_focus_entered() -> void:
	tween_button_entered()
	on_button_hover.emit()

func _on_texture_button_focus_exited() -> void:
	tween_button_exitted()

func _on_texture_button_mouse_entered() -> void:
	grab_button_focus()

func _on_texture_button_pressed() -> void:
	on_button_pressed.emit(action_id)
