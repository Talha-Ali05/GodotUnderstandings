class_name InteractionManager extends Node3D

@onready var player :Player= get_tree().get_first_node_in_group("player")

var interact_txt:="Press [E] to"
var interactions:Array[InteractionArea] = []
var can_interact := true

@onready var label: Label3D = $Label3D


func _process(_delta: float) -> void:
	if interactions.size() != 0 and can_interact:
		interactions.sort_custom(sort_by_dist)
		label.text = interact_txt + interactions[0].action_txt
		label.global_position = interactions[0].global_position
		label.global_position.y += 1.5
		label.global_position.x += label.scale.x
		label.global_position.z += label.scale.z
		label.show()
	else:
		label.hide()

func register_interaction(area:InteractionArea):
	interactions.push_back(area)

func withdraw_inteaction(area:InteractionArea):
	var index = interactions.find(area)
	if index != -1:
		interactions.remove_at(index)

func sort_by_dist(area1:InteractionArea,area2:InteractionArea):
	if player:
		var area1_to_player = area1.global_position.distance_to(player.global_position)
		var area2_to_player = area2.global_position.distance_to(player.global_position)
		return area1_to_player > area2_to_player
	

func _input(event: InputEvent) -> void:
	if event.is_action_just_pressed("Interact") and can_interact:
			if interactions.size() >0:
				can_interact = false
				label.hide()
				await interactions[0].action.call()
				can_interact = true
				
			
