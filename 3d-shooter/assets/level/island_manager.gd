class_name IslansdManager extends Node

enum IslandType { SIMPLE, COMBAT, HEAL, PARKOUR }

@export var simple_islands:  Array[PackedScene]
@export var combat_islands:  Array[PackedScene]
@export var heal_islands:    Array[PackedScene]
@export var parkour_islands: Array[PackedScene]

var island_pool: Dictionary

@onready var islands_placer: IslandPlacer =$"../IslandsPlacer"

var weights = {
	IslandType.SIMPLE:  100,
	IslandType.COMBAT:  0,
	IslandType.HEAL:    0,
}

func _ready() -> void:
	island_pool = {
		IslandType.SIMPLE : simple_islands,
		IslandType.COMBAT : combat_islands,
		IslandType.HEAL : heal_islands,
	}
	islands_placer.level_up.connect(difficulty_system)
	
	
func pick_island_type() -> IslandType:
	var total = 0
	for w in weights.values():
		total += w

	var roll = randi() % total
	var cumulative = 0
	for type in weights:
		cumulative += weights[type]
		if roll < cumulative:
			return type
	return IslandType.SIMPLE

func difficulty_system(rings: int) -> void:
	if rings == 0:
		return
	
	if rings % 2 == 0:
		weights[IslandType.SIMPLE] = max(0, weights[IslandType.SIMPLE] - 5)
	
	if rings % 3 == 0:
		weights[IslandType.COMBAT] += randi_range(5, 10)

	if rings % 4 == 0:
		weights[IslandType.HEAL] = max(20, weights[IslandType.HEAL] + 3)

func _on_timer_timeout() -> void:
	islands_placer.type =  pick_island_type()
	islands_placer.type = island_pool[islands_placer.type].pick_random()
