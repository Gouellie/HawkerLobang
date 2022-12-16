extends State

var table : Table

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "walking to table"	
	table = msg["table"]
	if is_instance_valid(table):
		_parent.set_navigation_position(table.position_cleaner)


func exit() -> void:
	pass


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	_state_machine.transition_to("Moving/CleaningTables/CleanTable", {"table" : table})


func end_shift() -> void:
	_state_machine.transition_to("Moving/End_Shift")
