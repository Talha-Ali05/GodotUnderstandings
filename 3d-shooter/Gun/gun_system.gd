extends Node3D
@export var gun:Gun
@onready var marker: Marker3D = $Marker
@onready var bullet_system: BulletSystem = $BulletSystem
@export var parent:Player


var current_gun:Node3D

func _ready() -> void:
	current_gun = gun.setup(self,marker)
	bullet_system.max_capacity = gun.bullets
	$ShootTimer.wait_time = gun.shoot_time


func _process(_delta: float) -> void:
	if gun.one_time_shoot:
		if Input.is_action_just_pressed("shoot"):
			if bullet_system.current_bullets >0 and bullet_system.can_shoot:
				gun_shoot()
	else:
		if Input.is_action_pressed("shoot"):
			if bullet_system.current_bullets > 0 and bullet_system.can_shoot:
				if $ShootTimer.time_left ==0:
					gun_shoot()
					$ShootTimer.start()
	bullet_system.reload()

func shoot():
	var new_bullet = gun.bullet_scene.instantiate()
	new_bullet.setup($Shooting_point)
	add_child(new_bullet)

func gun_shoot():
	shoot()
	push(gun.push_force,parent)
	bullet_system.use_bullet()
func push(push_force, new_parent:Player):
	if new_parent:
		var recoil_dir = -marker.global_transform.basis.z
		new_parent.velocity += recoil_dir*push_force


func swap_gun(new_gun: Gun):
	# remove old model
	if current_gun:
		current_gun.queue_free()
	
	# apply new gun data
	gun = new_gun
	bullet_system.max_capacity = gun.bullets
	$ShootTimer.wait_time = gun.shoot_time
	
	# spawn new model
	current_gun = gun.setup(self, marker)
