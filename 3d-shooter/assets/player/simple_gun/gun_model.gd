extends Node3D

const BULLET = preload("uid://dxm6dg7ugwqql")
@export var parent:Node3D
@export var shotting_point:Marker3D

@onready var bullet_system: Node = %Bullet_system


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and $ShootTimer.time_left <= 0:
		if bullet_system.current_bullets >0:
			shoot(parent,30)
			bullet_system.use_bullet()
	bullet_system.reload()
	
	

func shoot(new_parent:Node3D,recoil_speed):
	var new_bullet = BULLET.instantiate()
	new_bullet.setup(shotting_point)
	add_child(new_bullet)
	var recoil_dir = -shotting_point.global_transform.basis.z
	new_parent.velocity = recoil_dir*recoil_speed
	$ShootTimer.start()
