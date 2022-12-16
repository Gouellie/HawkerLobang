extends State

var table : Table
var owner_area_2d : Area2D


func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "moving to table"

	table = Global.table_manager.get_choped_table(owner)

	if not is_instance_valid(table):
		Events.emit_signal("send_feedback", Feedback.new("There are no tables available!"))		
		leave()
		return

	var table_position = table.get_sitting_position(owner.sit_index)
	owner_area_2d = owner.stall_detector
	_parent.set_navigation_position(table_position)	
	_check_if_already_in_range()


func exit() -> void:
	pass

	
func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if table == null:
		leave()


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func _check_if_already_in_range() -> void:
	if owner_area_2d is Area2D:
		if owner_area_2d.overlaps_area(table.table_range):
			# todo, check for proper index
			on_Area2D_body_entered(table, 0)


func on_Area2D_body_entered(body: Node2D, area_shape_index: int) -> void:
	if body == table and area_shape_index == owner.sit_index:
		_state_machine.transition_to("Idle/Sitting", {
			"table" : table
		})


func leave() -> void:
	
	_state_machine.transition_to("Moving/Leaving")
