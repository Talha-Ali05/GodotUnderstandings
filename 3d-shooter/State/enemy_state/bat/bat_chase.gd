class_name BatChase extends EnemyState


@export var model:Node3D

func physics_update(_delta):
	if player:
		model.rotation_degrees.y = 180
		var direction = -(parent.global_transform.origin - player.global_transform.origin).normalized()
		parent.look_at(player.global_transform.origin)
		parent.velocity = direction * speed
