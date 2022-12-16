extends State

var table : Table

func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "cleaning"	
	table = msg["table"]
	if is_instance_valid(table):
		table.cleaner_clean_table()
	_state_machine.transition_to("Moving/CleaningTables/FindTable")


func exit() -> void:
	pass


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func end_shift() -> void:
	_state_machine.transition_to("Moving/End_Shift")
