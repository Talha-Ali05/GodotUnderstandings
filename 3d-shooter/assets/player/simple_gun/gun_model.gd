extends Node3D

const BULLET = preload("uid://dxm6dg7ugwqql")

@onready var bullet_system: Node = %Bullet_system


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and $ShootTimer.time_left <= 0:
		if bullet_system.current_bullets >0:
			shoot($"../..",30)
			bullet_system.use_bullet()
	bullet_system.reload()
	
	

func shoot(parent:CharacterBody3D,recoil_speed):
	var new_bullet = BULLET.instantiate()
	new_bullet.setup($Marker3D)
	add_child(new_bullet)
	var recoil_dir = -$Marker3D.global_transform.basis.z
	parent.velocity = recoil_dir*recoil_speed
	$ShootTimer.start()
