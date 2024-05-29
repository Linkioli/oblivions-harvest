extends CharacterBody2D

const SPEED = 100

var screen_size
var direction: Vector2

@onready var animation_tree: AnimationTree = $AnimationTree 
@onready var dialog_interaction_area: Area2D = $DialogInteractionArea  


func _ready() -> void:
	screen_size = get_viewport_rect().size
	animation_tree.active = true


func _process(delta: float) -> void:
	update_animation_parameters()
	match direction:
		Vector2.DOWN: dialog_interaction_area.rotation_degrees = 0
		Vector2.UP: dialog_interaction_area.rotation_degrees = 180
		Vector2.RIGHT: dialog_interaction_area.rotation_degrees = -90
		Vector2.LEFT: dialog_interaction_area.rotation_degrees = 90


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	
	move_and_slide()


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Run/blend_position"] = direction
