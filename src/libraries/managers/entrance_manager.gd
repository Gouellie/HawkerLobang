extends Node2D
class_name EntranceManager

var entrances := []
var open_entrances := []

func _init() -> void:
	Global.entrance_manager = self


func _ready() -> void:
	Log.log_error(Global.expansion_manager.connect("expanded", self, "on_expanded"))
	entrances = get_children()
	for entrance in entrances:
		open_entrances.append(entrance)
		entrance.connect("entrance_close", self, "on_entrance_closed")
	_update_exits(Global.expansion_manager.real_top_left, Global.expansion_manager.real_bottom_right, Global.expansion_manager.cell_size)


func _random_entrance() -> Node2D:
	var size = open_entrances.size()
	if size == 0:
		return null
	var rand = randi() % size
	var entrance = open_entrances[rand]
	return entrance


func get_entrance() -> Vector2:
	var entrance = _random_entrance()
	if entrance:
		return entrance.global_position
	return Vector2.INF


func get_exit(pos : Vector2) -> Node2D:
	var closest_exit = null
	var closest_distance = 999999.0
	for entrance in open_entrances:
		var entrance_pos = entrance.global_position
		var distance = pos.distance_to(entrance_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_exit = entrance
	assert(closest_exit, "no valid exit found!")
	return closest_exit


func on_expanded(top_left : Vector2, bottom_right : Vector2, cell_size : Vector2) -> void:
	_update_exits(top_left, bottom_right, cell_size)


func _update_exits(top_left : Vector2, bottom_right : Vector2, cell_size : Vector2) -> void:
	var half_size = cell_size.x/2
	var width : float = bottom_right.x - top_left.x
	var height : float = bottom_right.y - top_left.y
	entrances[0].global_position = Vector2(bottom_right.x, top_left.y + half_size + height/2)
	entrances[1].global_position = Vector2(top_left.x + width/2 + half_size, bottom_right.y)
	entrances[2].global_position = Vector2(top_left.x + cell_size.x, top_left.y + half_size + height/2)
	entrances[3].global_position = Vector2(top_left.x + width/2 + half_size, top_left.y + cell_size.y)


func on_entrance_closed(entrance : Entrance, is_closed : bool) -> void:
	if not is_closed and not open_entrances.has(entrance):
		open_entrances.append(entrance)
	elif open_entrances.size() <= 1:
		entrance.cancel_close()
		return
	else:
		open_entrances.erase(entrance)
