extends RayCast3D

@onready var gun_model: Node3D =%gun

var original_rotation
var original_position
func _ready() -> void:
	original_rotation = gun_model.rotation
	original_position = gun_model.transform.origin.z
func  _process(_delta: float) -> void:
	if is_colliding():
		gun_model.rotation_degrees.x = lerp(gun_model.rotation_degrees.x, 45.0,.2)
		gun_model.transform.origin.z= original_position + .2
	else:
		gun_model.rotation = lerp(gun_model.rotation,original_rotation,.2)
		gun_model.transform.origin.z= original_position
