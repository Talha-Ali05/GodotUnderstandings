class_name BatChase
extends EnemyState

const ATTACK_RANGE := 5.0

func physics_update(_delta: float) -> void:
	if not player:
		return

	var direction := (player.global_position - parent.global_position).normalized()
	parent.look_at(player.global_position)
	parent.velocity = direction * speed + parent.knock_back_c.push_direction

	if parent.global_position.distance_to(player.global_position) <= ATTACK_RANGE:
		transtition.emit(self, "BatAttack")
