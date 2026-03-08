extends CharacterBody2D

var direction
var speed = 400

func _process(delta: float) -> void:
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = speed*direction
	move_and_slide()
