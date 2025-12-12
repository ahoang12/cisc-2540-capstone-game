extends CharacterBody3D

@export var lateral_speed: float = 8.0
@export var jump_velocity: float = 8.0
@export var fall_limit: float = -5.0   # how far you can fall before Game Over

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# --- Gravity ---
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		# Keep feet stable when on floor
		if velocity.y < 0.0:
			velocity.y = 0.0

	# --- Left / Right movement (move_left / move_right actions) ---
	var input_x := Input.get_axis("move_left", "move_right")
	velocity.x = input_x * lateral_speed

	# --- No forward/back movement; runner stays around z = 0 ---
	velocity.z = 0.0

	# --- Jump ---
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

		# Start moving the main platform when we jump
		var start_platform = get_tree().get_first_node_in_group("start_platform")
		if start_platform:
			start_platform.is_moving = true

	# --- Fall limit / Game Over check ---
	if global_transform.origin.y < fall_limit:
		_game_over()

	move_and_slide()


func _game_over() -> void:
	print("Game Over")
	get_tree().reload_current_scene()
