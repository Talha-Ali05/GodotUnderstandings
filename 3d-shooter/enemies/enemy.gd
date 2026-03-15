extends CharacterBody3D
var player:CharacterBody3D
@onready var bat_model: Node3D = $bat_model
@onready var animation_player: AnimationPlayer = $bat_model/AnimationPlayer
@onready var health_system: HealthSystem = $HealthSystem

var speed = 300.0

func setup(parent:Node3D, new_player:CharacterBody3D):
	global_position = parent.global_position
	player = new_player

func _ready() -> void:
	$HurtBox.hurt.connect(get_hurt)
	$HealthSystem.die.connect(func(): queue_free())

func _physics_process(delta: float) -> void:
	if player:
		var direction = -(global_transform.origin - player.global_transform.origin).normalized()
		look_at(player.global_transform.origin)
		bat_model.rotation_degrees.y = 180
		animation_player.play("Idle")
		velocity = speed * direction * delta
		move_and_slide()


func get_hurt(damage, hitbox):
	health_system.take_damage(hitbox.damage)
	
