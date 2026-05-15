class_name IslandPlacer extends Node3D

@export var base_radius: float = 20.0
@export var radius_increment: float = 10.0
@export var angle_step: float = 45.0
@export var angle_jitter: float = 5.0
@export var radius_jitter: float = 7.0

signal level_up(ring)


var current_radius: float
var current_angle: float = 0.0
var last_inst_pos: Vector3 = Vector3.ZERO

var instance
var val = 0
var rings := 0

var type

func _ready() -> void:
	current_radius = base_radius


func _on_timer_timeout() -> void:
	print("island created"+str(val))
	if not type:
		return

	var packed = type
	instance = packed.instantiate()
	
	var island_radius = 10.0  
	if instance.get("island_radius") != null:
		island_radius = instance.island_radius
 
	var actual_angle = deg_to_rad(current_angle + randf_range(-angle_jitter, angle_jitter))
	var actual_radius = current_radius + randf_range(-radius_jitter, radius_jitter)
	
	var candidate_pos = Vector3( cos(actual_angle), 0 ,sin(actual_angle)) * actual_radius

	var too_close = false
	for child in $Islands.get_children():
		if child.get("island_radius") == null:
			continue
		var min_dist = island_radius + child.island_radius
		if candidate_pos.distance_to(child.global_position) < min_dist:
			too_close = true
			break
		
	if too_close:
		actual_radius += island_radius * 1.3
		candidate_pos = Vector3(
			cos(actual_angle),
			0,
			sin(actual_angle)
		) * actual_radius
		current_radius = actual_radius
		
	$Islands.add_child(instance)
	instance.global_position = candidate_pos
	var tween = create_tween()
	tween.tween_property(instance,"global_position",Vector3(instance.global_position.x,randf_range(0.0,2.0),instance.global_position.z),.5)

	last_inst_pos = candidate_pos
	val+=1
	current_angle += angle_step
	if current_angle > 360.0:
		rings += 1
		current_radius += radius_increment
		$Timer.wait_time += .5
		current_angle = fmod(current_angle, 360.0)
		level_up.emit(rings)
