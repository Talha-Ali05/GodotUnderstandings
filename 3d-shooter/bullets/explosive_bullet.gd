extends Bullet

@export var blast_radius = 10
@export var blast_intensity = 30
func _on_body_entered(_body: Node3D) -> void:
	explode()

func explode() -> void:
	var bodies = $BlastArea.get_overlapping_bodies()  # Area3D with SphereShape
	
	for body in bodies:
		if body is Player:
			await  body.set_blast_time(.3)
			var distance = global_position.distance_to(body.global_position)
			var falloff = 1.0 - (distance / blast_radius)
			var direction = (body.global_position - global_position).normalized()
			var blast_force = direction * blast_intensity * falloff
			body.velocity = blast_force
		if body.is_in_group("enemies"):
			body.health_system.take_damage(50)
	
	queue_free()
