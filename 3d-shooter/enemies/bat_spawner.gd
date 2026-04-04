extends StaticBody3D
const ENEMY = preload("uid://dsqrj3upoggry")
var player:Node3D
@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_box: HurtBox = $HurtBox



func _ready() -> void:
	hurt_box.hurt.connect(take_damage)
	health_system.die.connect(func():	queue_free())
	player = get_tree().get_first_node_in_group("player")
	$Timer.wait_time = randi_range(1,3)
func spawn_bat():
	var bat = ENEMY.instantiate()
	$Marker3D.add_child(bat)
	if player:
		bat.setup($Marker3D,player)

func take_damage(damage,area:Area3D):
	health_system.take_damage(area.damage)

func _on_timer_timeout() -> void:
	spawn_bat()
	$Timer.wait_time = randi_range(3,5)
