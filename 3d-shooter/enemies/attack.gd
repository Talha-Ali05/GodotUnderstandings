class_name BatAttack
extends EnemyState

const CHASE_RANGE    := 12.0
const HIT_RANGE      := 1.2
@export var retreat_duration := 1.0

var _charging: bool
var _retreat_timer: float

func enter() -> void:
	_charging = true
	_retreat_timer = 0.0

func physics_update(delta: float) -> void:
	if not player:
		return

	var to_player := player.global_position - parent.global_position
	var flat_to_player := Vector3(to_player.x, 0, to_player.z)
	var distance  := flat_to_player.length()
	var direction := to_player.normalized()

	if distance > CHASE_RANGE:
		transtition.emit(self, "BatChase")
		return

	if _charging:
		parent.look_at(player.global_position)
		parent.velocity = direction * speed
		if distance <= HIT_RANGE:
			_charging = false
			_retreat_timer = retreat_duration
	else:
		parent.velocity = -direction * speed   # back off, no turn
		_retreat_timer -= delta
		if _retreat_timer <= 0.0:
			_charging = true                   # charge again
