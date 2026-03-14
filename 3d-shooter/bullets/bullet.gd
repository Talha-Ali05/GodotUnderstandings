extends Area3D


var speed = 55.0
var max_range := 45.0
var travel_distance = 0

func setup(parent:Node3D):
	global_transform = parent.global_transform

func _physics_process(delta: float) -> void:
	position += transform.basis.z * speed * delta
	travel_distance += speed*delta
	if travel_distance > max_range:
		queue_free()
