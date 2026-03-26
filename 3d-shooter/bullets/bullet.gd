class_name Bullet extends Area3D


@export var speed = 70.0
@export var max_range := 50.0


var travel_distance = 0

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func setup(parent:Marker3D):
	self.global_transform = parent.global_transform

func _physics_process(delta: float) -> void:
	position += transform.basis.z * speed * delta
	travel_distance += speed*delta
	if travel_distance > max_range:
		queue_free()


func _on_body_entered(_body: Node3D) -> void:
	queue_free()
