extends Node3D
@export var gun:Gun
@onready var bullet_system: BulletSystem = $BulletSystem
@export var parent:Player
@onready var label: Label = $Label
@onready var gun_sound_3d: AudioStreamPlayer3D = $GunSound3D


var guns:Array[GunsData.Guns] = [GunsData.Guns.PISTOL,GunsData.Guns.LAUNCHER]
var current_gun_data:GunsData.Guns

var current_gun:GunModel

func _ready() -> void:
	current_gun = gun.setup(self)
	bullet_system.max_capacity = gun.bullets
	if gun.shoot_time:
		$ShootTimer.wait_time = gun.shoot_time
	gun_sound_3d.stream = gun.gun_sound


func _process(_delta: float) -> void:
	label.text = str(bullet_system.current_bullets)
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
	if Input.is_action_just_pressed("Weapon1"):
		current_gun_data = guns[0]
		swap_gun(current_gun_data)
	if Input.is_action_just_pressed("Weapon2"):
		current_gun_data = guns[1]
		swap_gun(current_gun_data)
		
	bullet_system.reload()

func shoot():
	var new_bullet = gun.bullet_scene.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.setup(current_gun.shoot_point)
	gun_sound_3d.pitch_scale = randf_range(.9,1.5)
	gun_sound_3d.play()
	current_gun.spark.show()
	await get_tree().create_timer(.1).timeout
	current_gun.spark.hide()

func gun_shoot():
	shoot()
	push(gun.push_force,parent)
	bullet_system.use_bullet()
	

func push(push_force, new_parent:Player):
	if new_parent:
		var recoil_dir = -current_gun.shoot_point.global_transform.basis.z
		new_parent.velocity += recoil_dir*push_force


func swap_gun(new_gun:GunsData.Guns):
	if current_gun:
		current_gun.queue_free()
	
	gun = GunsData.guns_data[new_gun]
	bullet_system.max_capacity = gun.bullets
	gun_sound_3d.stream = gun.gun_sound
	if gun.shoot_time > 0:
		$ShootTimer.wait_time = gun.shoot_time
	
	current_gun = gun.setup(self)
