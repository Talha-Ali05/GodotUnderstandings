extends Bullet

@export var blast_radius = 10
@export var blast_intensity = 30
@onready var explosion_player_3d: AudioStreamPlayer3D =%ExplosionPlayer3D


func _on_body_entered(_body: Node3D) -> void:
	explode()


func explode() -> void:
	var bodies = $BlastArea.get_overlapping_bodies()
	explosion_player_3d.play()
	for body in bodies:
		if body is Player:
			var distance = global_position.distance_to(body.global_position)
			var falloff = 1.0 - (distance / blast_radius)
			var direction = (body.global_position - global_position).normalized()
			var blast_force = direction * blast_intensity * falloff
			body.push_velo = blast_force
			body.set_blast_time(.3)
		if body is Enemy:
			body.health_system.take_damage(100)
	$projectile_model.visible = false
	$BlastArea/CollisionShape3D.disabled = true
	await explosion_player_3d.finished
	queue_free()
