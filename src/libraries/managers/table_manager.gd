extends Reference
class_name TableManager

var _tables = []

func _init() -> void:
	Global.table_manager = self
	

func register_table(table : Table) -> void:
	if not _tables.has(table):
		_tables.push_back(table)


func remove_table(table : Table) -> void:
	if _tables.has(table):
		_tables.erase(table)

		
func get_table(pos : Vector2) -> Table:
	var closest_table = null
	var closest_distance = 999999.0
	for table in _tables:
		var table_pos = table.global_position
		var distance = pos.distance_to(table_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_table = table
	if not closest_table:
		return null
	_tables.erase(closest_table)
	closest_table.table_reserved()
	return closest_table
