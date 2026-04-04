class_name EnemyState extends State

@export var speed :float
@export var parent:CharacterBody3D
var player:Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
