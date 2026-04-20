class_name InteractionArea extends Area3D


@export var action_txt := "Interaction"

var action:Callable = func():	pass


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	InteractManager.register_interaction(self)


func _on_body_exited(body: Node3D) -> void:
	InteractManager.withdraw_interaction(self)
