class_name Enemy extends CharacterBody3D
var player:CharacterBody3D
@onready var bat_model: Node3D = $bat_model
@onready var animation_player: AnimationPlayer = $bat_model/AnimationPlayer
@onready var health_system: HealthSystem = $HealthSystem
@onready var knock_back_c: KnockBackS = $KnockBackC

var speed = 150.0

func setup(parent:Node3D, new_player:CharacterBody3D):
	global_position = parent.global_position
	player = new_player

func _ready() -> void:
	$HurtBox.hurt.connect(get_hurt)
	$HealthSystem.die.connect(func(): queue_free())

func _physics_process(_delta: float) -> void:
	$bat_model.rotation_degrees.y = 180
	move_and_slide()


func get_hurt(damage, hitbox):
	knock_back_c.push(self,hitbox,Vector3.ZERO)
	health_system.take_damage(hitbox.damage)
	
