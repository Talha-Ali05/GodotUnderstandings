extends CharacterBody3D
var player:CharacterBody3D
@onready var bat_model: Node3D = $bat_model
@onready var animation_player: AnimationPlayer = $bat_model/AnimationPlayer

var speed = 100.0

func setup(parent:Node3D, new_player:CharacterBody3D):
	global_position = parent.global_position
	player = new_player

func _physics_process(delta: float) -> void:
	if player:
		var direction = -(global_transform.origin - player.global_transform.origin).normalized()
		look_at(player.global_position)
		bat_model.rotation_degrees.y = 180
		animation_player.play("Idle")
		velocity = speed * direction * delta
		move_and_slide()
