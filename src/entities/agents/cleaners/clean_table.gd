extends State

var table : Table

const time_to_clean_modifier : int = 5
var time_to_clean : int = 0
var time_cleaning : int = 0


func enter(msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "cleaning"	
	table = msg["table"]
	if is_instance_valid(table):
		time_cleaning = 0
		# warning-ignore:narrowing_conversion
		time_to_clean = time_to_clean_modifier * table.cleaner_clean_table() / 100


func exit() -> void:
	pass


func on_time_ellapsed(_dateTime : DateTime) -> void:
	time_cleaning += 1
	if time_cleaning >= time_to_clean:
		_state_machine.transition_to("Moving/CleaningTables/FindTable")


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func end_shift() -> void:
	_state_machine.transition_to("Moving/End_Shift")
