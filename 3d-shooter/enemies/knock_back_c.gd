class_name KnockBackS extends Node
@export var push_distance = 5
var push_direction:Vector3

func push(parent:Node3D,target:Node3D,dir:=Vector3.ZERO):
	var tween = get_tree().create_tween()
	var target_dir = dir if dir else (target.position - parent.position).normalized()
	target_dir = Vector3(-target_dir.x,0,target_dir.z)
	var new_target = -1 * target_dir * push_distance
	tween.tween_property(self,"push_direction",new_target,0.1)
	tween.tween_property(self,"push_direction",Vector3.ZERO,0.2)
