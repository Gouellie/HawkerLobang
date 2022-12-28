extends Reference
class_name TableManager

var _tables = []
var _dirty_tables = []
var _choped_tables = {}

func _init() -> void:
	Global.table_manager = self
	Log.log_error(Events.connect("clear_patrons_requested", self, "clean_all"))
	

func register_table(table : Table) -> void:
	if not _tables.has(table):
		_tables.push_back(table)


func remove_table(table : Table) -> void:
	if _tables.has(table):
		_tables.erase(table)
	if _choped_tables.has(table):
		_choped_tables.erase(table)
	if _dirty_tables.has(table):
		_dirty_tables.erase(table)


func chope_table(patron : Patron) -> Table:
	var pos = patron.global_position
	var patron_counts = patron.group_size
	
	var desired_seats_count = _get_desired_seats_count(patron_counts)
	var closest_table = null
	var closest_table_wrong_seat = null
	var closest_distance = 999999.0
	for table in _tables:
		if table.seats_count < desired_seats_count:
			continue
		if table.dirtiness > 90.0:
			continue
		var table_pos = table.global_position
		var distance = pos.distance_to(table_pos)
		if distance < closest_distance:
			closest_distance = distance
			if table.seats_count > desired_seats_count:
				closest_table_wrong_seat = table
			else:	
				closest_table = table
				
	if not closest_table :
		# no available table found with the desired seat count
		# checking if a table exist that has too many seats
		closest_table = closest_table_wrong_seat
	if not closest_table:
		# no such luck
		return null
	_tables.erase(closest_table)
	closest_table.table_reserved(true)
	_choped_tables[patron.group_id] = closest_table
	return closest_table


func get_choped_table(patron : Patron) -> Table:
	var group_id = patron.group_id
	if _choped_tables.has(group_id):
		return _choped_tables[group_id]
	return null	


func find_dirty_table(pos : Vector2) -> Table:
	var closest_table = null
	var closest_distance = 999999.0
	for table in _dirty_tables:
		var table_pos = table.global_position
		var distance = pos.distance_to(table_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_table = table
	return closest_table


func find_nearest_table(pos : Vector2, visited_tables : Array) -> Table:
	var closest_table = null
	var closest_distance = 999999.0
	for table in _tables:
		if visited_tables.has(table):
			continue		
		var table_pos = table.global_position
		var distance = pos.distance_to(table_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_table = table
	if not closest_table:
		return null
	return closest_table


func free_table(patron : Patron) -> void:
	var group_id = patron.group_id
	if not _choped_tables.has(group_id):
		return
	var table = _choped_tables[group_id]
	_choped_tables.erase(group_id)
	if not is_instance_valid(table):
		return
	table.table_reserved(false)
	_tables.append(table)


func _get_desired_seats_count(patron_counts : int) -> int:
	if patron_counts <= 2:
		return 2
	elif patron_counts <= 4:
		return 4
	else : 
		return 8


func notify_dirty_table(table : Table, is_dirty : bool) -> void:
	if is_dirty and not _dirty_tables.has(table):
		_dirty_tables.append(table)
	else:
		_dirty_tables.erase(table)


func clean_all() -> void:
	_choped_tables.clear()
	_dirty_tables.clear()
	for table in _tables:
		table.reset()
