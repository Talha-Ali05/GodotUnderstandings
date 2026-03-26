extends ColorRect
 
# ── tunables ───────────────────────────────────────────────────
## Fade value at full health (0.0 = completely invisible effect)
@export var min_fade: float = 0.001
## Fade value at zero health (keep below ~0.10 to stay readable)
@export var max_fade: float = 0.02
## How fast the effect lerps to its target each frame
@export var lerp_speed: float = 4.0
# ───────────────────────────────────────────────────────────────
 
@onready var _mat: ShaderMaterial = material as ShaderMaterial
 
var _player: Player
 
func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
 
func _process(delta: float) -> void:
	if not _player:
		return
 
	var hp_ratio: float = float(_player.health_system.health) \
						/ float(_player.health_system.max_health)
	# invert: low health → high fade
	var target_fade: float = lerp(max_fade, min_fade, hp_ratio)
 
	var current_fade: float = _mat.get_shader_parameter("fade")
	_mat.set_shader_parameter(
		"fade",
		lerp(current_fade, target_fade, lerp_speed * delta)
	)
