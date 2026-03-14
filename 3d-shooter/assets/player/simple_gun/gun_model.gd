extends Node3D

const BULLET = preload("uid://dxm6dg7ugwqql")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and $ShootTimer.time_left <= 0:
		shoot()

func shoot():
	var new_bullet = BULLET.instantiate()
	new_bullet.setup($Marker3D)
	add_child(new_bullet)
	$ShootTimer.start()
