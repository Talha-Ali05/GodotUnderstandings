class_name Player extends CharacterBody3D

@export var speed = 9.0
@export var sprint_speed = 12.0
@export var jump_force = 12.0
var base_speed = speed
@export var fric = 80.0    

var base_fov = 75.0
var fov_change = 2.0


var head_bob_freq = 2.0
var head_bob_ampl = .1
var time:float
var t_bob:float

@onready var camera_3d: Camera3D = $Camera3D
@onready var bullet_system: Node = %Bullet_system
@onready var bullets: Label = $CanvasLayer/Bullets


@onready var hurt_box: HurtBox = $HurtBox
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar


var can_jump = true
var was_on_floor:bool

var original_cam_pos

func _ready() -> void:
	gCollectable.collected.connect(collect_system)
	original_cam_pos = camera_3d.transform.origin
	health_system.die.connect(game_over)
	health_bar.max_value = health_system.max_health
	hurt_box.hurt.connect(get_hurt)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * .5
		camera_3d.rotation_degrees.x -= event.relative.y * .2
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x,-80,80)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta: float) -> void:
	time +=_delta
	health_bar.health = health_system.health
	
	movement_system(_delta)
	jump_system(_delta)

	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = base_speed
	show_bullets()
	t_bob = time * velocity.length() * float(is_on_floor())
	camera_3d.transform.origin = original_cam_pos + head_bob(t_bob)
	
	var velo_clam = clamp(velocity.length(),.5,sprint_speed*2)
	var target_fov = base_fov + (fov_change * velo_clam)
	camera_3d.fov = lerp(camera_3d.fov,target_fov,0.5)
	
	
	
	move_and_slide()
	was_on_floor = is_on_floor()



func movement_system(_delta):
	var input_dir_2d = Input.get_vector("move_left","move_right","move_forward","move_backward")
	var input_dir_3d = Vector3(input_dir_2d.x,0.0,input_dir_2d.y)
	var direction = (transform.basis * input_dir_3d).normalized()
	if input_dir_2d:
		velocity.x= speed*direction.x
		velocity.z= speed*direction.z
	else:
		velocity.x= move_toward(velocity.x,0,fric * _delta)
		velocity.z= move_toward(velocity.z,0,fric * _delta)


func show_bullets():
	bullets.text = str(bullet_system.current_bullets)+"/*"
	if bullet_system.current_bullets <=0:
		bullets.add_theme_color_override("font_color","RED")
	else:
		bullets.add_theme_color_override("font_color","GREEN")

func jump_system (_delta):
	if was_on_floor and not is_on_floor():
		$coyoteTime.start()
	velocity.y -= 35*_delta
	velocity.y = clamp(velocity.y,-100,20)
	if is_on_floor():
		can_jump = true
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = jump_force
		can_jump = false
	elif Input.is_action_just_released("jump") and velocity.y >0.0:
		velocity.y = 0
	if velocity.y <0.0 and not is_on_floor():
		var fall_gravity = 1.0 + (0.05 * _delta * 60)
		velocity.y *= fall_gravity
	if $coyoteTime.time_left <=0.0:
		can_jump = false
func get_hurt(damage,hitbox):
	print(health_system.health)
	health_system.take_damage(hitbox.damage)

func collect_system(value):
	health_system.heal(value)

func head_bob(new_time) ->Vector3:
	var pos:= Vector3.ZERO
	pos.y = sin(new_time*head_bob_freq)*head_bob_ampl
	pos.x = cos(new_time*head_bob_freq/2)*head_bob_ampl
	return pos

func game_over():
	pass
