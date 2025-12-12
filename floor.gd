extends Node3D

@export var platform_scene: PackedScene
@export var spawn_z: float = -30.0   # where new platforms appear (far in front)
@export var lane_width: float = 3.0  # distance between left / center / right lanes
@export var spawn_interval: float = 1.0  # seconds between spawns

func _ready() -> void:
	randomize()

	# Create a timer to spawn repeatedly
	var timer := Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

	# Optionally spawn a few at start so it's not empty
	for i in range(4):
		_spawn_platform()

func _on_timer_timeout() -> void:
	_spawn_platform()

func _spawn_platform() -> void:
	if platform_scene == null:
		return

	var platform: StaticBody3D = platform_scene.instantiate()

	# Choose a lane: left, center, or right
	var lanes = [-lane_width, 0.0, lane_width]
	var lane_x = lanes[randi() % lanes.size()]

	var pos = Vector3(lane_x, 0.0, spawn_z)
	platform.global_transform.origin = pos

	get_tree().current_scene.add_child(platform)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		queue_free()
