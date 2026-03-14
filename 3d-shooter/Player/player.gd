extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D
var speed = 5.5

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
	var input_dir_2d = Input.get_vector("move_left","move_right","move_forward","move_backward")
	var input_dir_3d = Vector3(input_dir_2d.x,0.0,input_dir_2d.y)
	var direction = transform.basis * input_dir_3d
	velocity.x= direction.x *speed
	velocity.y -= 20.0*_delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 15
	elif Input.is_action_just_released("jump") and velocity.y >0.0:
		velocity.y = 0.0
	velocity.z= direction.z *speed
	
	
	move_and_slide()
