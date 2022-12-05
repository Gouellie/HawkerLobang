extends State

var exit = Node2D

func enter(_msg: Dictionary = {}) -> void:
	if owner.label_state :
		owner.label_state.text = "leaving"
	if not owner.is_in_patron_group or owner.is_group_leader:
		Global.table_manager.free_table(owner)
	leave()


func leave()-> void:
	exit = Global.entrance_manager.get_exit(owner.global_position)
	var unspawn_pos = exit.global_position
	_parent.set_navigation_speed(Global.current_speed)
	_parent.set_navigation_position(unspawn_pos)


func on_time_ellapsed(time : DateTime) -> void:
	_parent.on_time_ellapsed(time)


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func character_target_reached() -> void:
	Events.emit_signal("patron_leaving", owner)


func on_Area2D_body_entered(body: Node2D, _area_shape_index: int) -> void:
	if body == exit:
		Events.emit_signal("patron_leaving", owner)
