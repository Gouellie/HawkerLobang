extends State

var table : Table

const MAX_VISITED_TABLE : int = 5
var visited_tables_index : int = 0
var visited_tables := []


func _ready() -> void:
	for i in MAX_VISITED_TABLE:
		visited_tables.append(null)
	

func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "find table"


func exit() -> void:
	pass


func on_time_ellapsed(_dateTime : DateTime) -> void:
	table = Global.table_manager.find_dirty_table(owner.global_position)
	if not table:
		# no dirty table found, looking for any other tables
		table = Global.table_manager.find_nearest_table(owner.global_position, visited_tables)
		if table:
			visited_tables[visited_tables_index] = table
			visited_tables_index = wrapi(visited_tables_index + 1, 0, MAX_VISITED_TABLE)
		else:
			return
	if table:
		_state_machine.transition_to("Moving/CleaningTables/WalkToTable", {"table" : table})


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func end_shift() -> void:
	_state_machine.transition_to("Moving/End_Shift")
