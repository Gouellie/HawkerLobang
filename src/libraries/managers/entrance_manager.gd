extends Node2D
class_name EntraceManager

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
	
