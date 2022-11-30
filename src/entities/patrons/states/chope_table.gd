extends State

var table : Table
var owner_area_2d : Area2D

func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "chope table"

	table = Global.table_manager.chope_table(owner)
	
	if owner.is_group_leader:
		_state_machine.transition_to("Moving/Browsing")
	else:
		_state_machine.transition_to("Moving/MovingToTable")


func exit() -> void:
	pass


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func leave() -> void:
	_state_machine.transition_to("Moving/Leaving")
