class_name Player extends CharacterBody3D

@export var speed = 9.0
@export var sprint_speed = 12.0
@export var jump_force = 12.0
var base_speed = speed
@export var fric = 30.0    
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var base_fov = 75.0
var fov_change = 2.0


var head_bob_freq = 1.5
var head_bob_ampl = .2
var time:float
var t_bob:float

var blast_timer:float = .3

@onready var camera_3d: Camera3D = $head/Camera3D
@onready var head: Node3D = $head



@onready var hurt_box: HurtBox = $HurtBox
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var gun_system: Node3D = %GunSystem



var can_jump = true
var was_on_floor:bool


var walk_can_play:=true
var walk_landed:bool


var original_cam_pos
var original_gun_pos

func _ready() -> void:
	original_gun_pos = gun_system.transform.origin
	original_cam_pos = camera_3d.transform.origin
	health_system.die.connect(game_over)
	health_bar.max_value = health_system.max_health
	hurt_box.hurt.connect(get_hurt)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * .5
		head.rotation_degrees.x -= event.relative.y * .2
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-80,80)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta: float) -> void:
	
	if blast_timer >0:
		blast_timer -= _delta
	time +=_delta
	health_bar.health = health_system.health
	
	
	movement_system(_delta)
	gun_positioning()
	jump_system(_delta)

	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = base_speed
	t_bob = time * velocity.length() * float(is_on_floor())
	if velocity.length() >= base_speed - 1 or velocity.length() <=-base_speed - 1 :
		camera_3d.transform.origin = original_cam_pos + head_bob(t_bob)
		
	var velo_clam = clamp(velocity.length(),.5,sprint_speed*2)
	var target_fov = base_fov + (fov_change * velo_clam)
	camera_3d.fov = lerp(camera_3d.fov,target_fov,0.5)
	
	
	
	move_and_slide()
	was_on_floor = is_on_floor()
	
	if is_on_floor() and not walk_landed:
		$WalkAudio3D.play()
	if walk_landed and not is_on_floor():
		$WalkAudio3D.play()
	
	walk_landed = is_on_floor()


func movement_system(_delta):
	var input_dir_2d = Input.get_vector("move_left","move_right","move_forward","move_backward")
	var input_dir_3d = Vector3(input_dir_2d.x,0.0,input_dir_2d.y)
	var direction = (transform.basis * input_dir_3d).normalized()
	if input_dir_2d:
		velocity.x= speed*direction.x
		velocity.z= speed*direction.z
	if blast_timer <= 0:
		var current_fric = fric if is_on_floor() else 8.0
		velocity.x= move_toward(velocity.x,0,current_fric * _delta)
		velocity.z= move_toward(velocity.z,0,current_fric * _delta)


func jump_system (_delta):
	if was_on_floor and not is_on_floor():
		$coyoteTime.start()
	velocity.y -= 35*_delta
	velocity.y = clamp(velocity.y,-100,50)
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
	health_system.take_damage(hitbox.damage)
	$HurtAudio3D.play()

func gun_positioning():
	if not velocity.length():
		gun_system.transform.origin = original_gun_pos

func collect_system(value):
	health_system.heal(value)

func head_bob(new_time) ->Vector3:
	var pos:= Vector3.ZERO
	pos.y = sin(new_time*head_bob_freq)*head_bob_ampl
	pos.x = cos(new_time*head_bob_freq/2)*head_bob_ampl
	var threshold = -head_bob_ampl +.002
	if pos.y > threshold:
		walk_can_play = true
	elif pos.y < threshold and walk_can_play:
		walk_can_play = false
		$WalkAudio3D.play()
	return pos
	

func set_blast_time(value):
	blast_timer = value



func game_over():
	pass
