extends Node2D
class_name EntranceManager

var entrances := []


func _init() -> void:
	Global.entrance_manager = self


func _ready() -> void:
	entrances = get_children()


func _random_entrance() -> Node2D:
	var size = entrances.size()
	if size == 0:
		return null
	var rand = randi() % size
	var entrance = entrances[rand]
	return entrance


func get_entrance() -> Vector2:
	var entrance = _random_entrance()
	if entrance:
		return entrance.global_position
	return Vector2.ZERO


func get_exit(pos : Vector2) -> Node2D:
	var closest_exit = null
	var closest_distance = 999999.0
	for entrance in entrances:
		var entrance_pos = entrance.global_position
		var distance = pos.distance_to(entrance_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_exit = entrance
	assert(closest_exit, "no valid exit found!")
	return closest_exit
	

