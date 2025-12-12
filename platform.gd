extends StaticBody3D

@export var move_speed: float = 8.0      # how fast platform moves toward player
@export var destroy_z: float = 10.0      # when it's past this z, we delete it

func _physics_process(delta: float) -> void:
	# Move toward +Z (toward camera/player if they are near z = 0)
	translate(Vector3(0, 0, move_speed * delta))

	# Once the platform is far behind the player, remove it
	if global_transform.origin.z > destroy_z:
		queue_free()
