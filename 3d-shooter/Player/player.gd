extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D
@export var speed = 6.5
@export var sprint_speed = 10
var base_speed = speed
@export var acce = 25
@export var fric = 30


var can_jump = true
var was_on_floor:bool

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * .5
		camera_3d.rotation_degrees.x -= event.relative.y * .2
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x,-80,80)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta: float) -> void:
	
	movement_system(_delta)
	jump_system(_delta)

	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = base_speed
	
	
	move_and_slide()
	was_on_floor = is_on_floor()



func movement_system(_delta):
	var input_dir_2d = Input.get_vector("move_left","move_right","move_forward","move_backward")
	var input_dir_3d = Vector3(input_dir_2d.x,0.0,input_dir_2d.y)
	var direction = (transform.basis * input_dir_3d).normalized()
	if input_dir_2d:
		velocity.x= move_toward(velocity.x,speed*direction.x,acce * _delta)
		velocity.z= move_toward(velocity.z,speed*direction.z,acce * _delta)
	else:
		velocity.x= move_toward(velocity.x,0,fric * _delta)
		velocity.z= move_toward(velocity.z,0,fric * _delta)



func jump_system (_delta):
	if was_on_floor and not is_on_floor():
		$coyoteTime.start()
	velocity.y -= 20.0*_delta
	if is_on_wall_only():
		velocity.y /=1.5
	velocity.y = clamp(velocity.y,-75,20)
	if is_on_floor():
		can_jump = true
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = 12
		can_jump = false
	elif Input.is_action_just_released("jump") and velocity.y >0.0:
		velocity.y = 2
	if velocity.y <0.0 and not is_on_floor():
		var fall_gravity = 1.0 + (0.05 * _delta * 60)
		velocity.y *= fall_gravity
	if $coyoteTime.time_left <=0.0:
		can_jump = false
