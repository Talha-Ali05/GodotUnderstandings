class_name Gun extends Resource

@export var model:PackedScene
@export var one_time_shoot:bool
@export var reload_time:float
@export var bullets:int
@export var push_force:float
@export var shoot_time:float
@export var bullet_scene:PackedScene



func setup(parent:Node3D) -> Node3D:
	var instance = model.instantiate()
	parent.add_child(instance)
	if instance:
		instance.rotation_degrees.y = 180
	return instance
