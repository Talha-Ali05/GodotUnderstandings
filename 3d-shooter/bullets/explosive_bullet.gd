extends Bullet

@export var blast_radius = 10
@export var blast_intensity = 30
func _on_body_entered(_body: Node3D) -> void:
	explode()

func explode() -> void:
	# Use an overlapping sphere check instead of body_entered
	var space_state = get_world_3d().direct_space_state
	var bodies = $BlastArea.get_overlapping_bodies()  # Area3D with SphereShape
	
	for body in bodies:
		var distance = global_position.distance_to(body.global_position)
		var falloff = 1.0 - (distance / blast_radius)
		var direction = (body.global_position - global_position).normalized()
		if body is Player:
			body.velocity += direction * blast_intensity * falloff
	
	queue_free()
